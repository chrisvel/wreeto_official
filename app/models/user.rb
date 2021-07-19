class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :database_authenticatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  before_validation :setup_account, on: :create
  before_validation :setup_username, on: :create
  before_create :setup_add_ons
  after_create :setup_default_categories
  after_create :setup_inbox
  after_create :send_email_to_admin

  belongs_to :account
  has_many :notes, class_name: "Note", dependent: :destroy

  has_many :categories, dependent: :destroy
  has_many :projects, dependent: :destroy

  has_many :tags, dependent: :destroy
  has_many :backups, dependent: :destroy
  has_many :digital_gardens, dependent: :destroy
  has_many :inquiries, dependent: :destroy

  validates :email, uniqueness: true, 'valid_email_2/email': { mx: true, disposable: true }
  validates :username, uniqueness: true

  def owner_of?(resource)
    self == resource.user
	end

  def send_thank_you_sign_up_mail
    SocialLoginMailer.with(user: self).thank_you_sign_up.deliver_later
  end

  def signed_up_type
    if self.token.blank?
      'wreeto'
    else
      'google'
    end
  end
  
  def is_admin?
    self.email == 'chrisveleris@gmail.com'
  end
	
	def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
      user = User.new(
        email: data['email'],
        password: Devise.friendly_token[0,20],
        token: access_token.credentials.token,
        expires: access_token.credentials.expires,
        expires_at: access_token.credentials.expires_at,
        refresh_token: access_token.credentials.refresh_token
      )
      user.skip_confirmation!
      user.save!
      user.send_thank_you_sign_up_mail
    end
    user
  end

  def has_any_digital_garden_enabled?
    digital_gardens.select(&:enabled)&.any?
  end

  def has_dg_addon?
    has_addon?('digital_gardens')
  end

  def has_attachments_addon?
    has_addon?('attachments')
  end

  def has_wiki_addon?
    has_addon?('wiki')
  end

  def has_backlinks_addon?
    has_addon?('backlinks')
  end

  def has_graph_addon?
    has_addon?('graph')
  end

  def current_plan 
    account.subscriptions.first.plan.slug.to_sym
  end

  def plan_free?
    current_plan == :free 
  end

  def plan_trial?
    current_plan == :trial 
  end

  def plan_premium?
    current_plan == :premium 
  end

  def inbox
    categories.inbox
  end

  private 

  def has_addon?(name)
    add_ons.include?(name)
  end

  def send_email_to_admin
    SignUpNotifyMailer.with(user: self).user_signed_up.deliver_later
  end

  def setup_inbox 
    Category.create!(title: 'Inbox', deletable: false,  user_id: self.id)
  end

  def setup_default_categories
    Category.create!(title: 'Personal', deletable: true,  user_id: self.id)
    Category.create!(title: 'Ideas',    deletable: true,  user_id: self.id)
  end

  def setup_account
    build_account
  end

  def setup_username 
    self.username = self.email 
  end

  def setup_add_ons
    self.add_ons = ['digital_gardens']
  end
end
