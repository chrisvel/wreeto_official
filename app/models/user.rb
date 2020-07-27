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
         :database_authenticatable

  after_create :setup_default_categories
  after_create :send_email_to_admin

  has_many :notes, class_name: "Note", dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :email, uniqueness: true
  validates :username, uniqueness: true

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

  def owner_of?(resource)
    self == resource.user
  end
end
