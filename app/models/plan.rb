class Plan < ApplicationRecord

  before_validation :generate_slug

  has_many :subscriptions

  def trial?
    slug == 'trial'
  end

  def premium?
    slug == 'premium'
  end

  private 

  def generate_slug
    self.slug ||= name.parameterize if name.present?
  end
end
