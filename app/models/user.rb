# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  firstname              :string
#  lastname               :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  provider               :string
#  uid                    :string
#  token                  :string
#  expires_at             :integer
#  expires                :boolean
#  refresh_token          :string
#

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

  after_create :setup_default_categories
  after_create :send_email_to_admin

  # has_many :items, dependent: :destroy
  has_many :inventory_items, class_name: "Inventory::Item", dependent: :destroy
  has_many :inventory_notes, class_name: "Inventory::Note", dependent: :destroy
  has_many :categories, dependent: :destroy

  def setup_default_categories
    Category.create!(title: 'Personal',      deletable: true,  user_id: self.id)
    Category.create!(title: 'Projects',      deletable: false, user_id: self.id)
    Category.create!(title: 'Uncategorized', deletable: false, user_id: self.id)
    Category.create!(title: 'Ideas',         deletable: true,  user_id: self.id)
    Category.create!(title: 'Thoughts',      deletable: true,  user_id: self.id)
  end

  def send_email_to_admin
    SignUpNotifyMailer.with(user: self).user_signed_up.deliver_later
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

  def thoughts_category
    self.categories.find_by(slug: 'thoughts')
  end

  def ideas_category
    self.categories.find_by(slug: 'ideas')
  end

  def owner_of?(resource)
    self == resource.user
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
end
