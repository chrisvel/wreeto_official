class Account < ApplicationRecord

  # Callbacks
  before_validation :setup_subscription, on: :create

  # Associations
  has_many :users
  has_many :subscriptions

  private 
  
  def setup_subscription
    subscriptions.build(plan: Plan.find_by(slug: 'free'))
  end
end
