class Inquiry < ApplicationRecord
  enum reason: {
    'support_request': 0, 
    'bug':             1, 
    'feature_request': 2,
    'sales':           3
  }

  belongs_to :user

  validates :reason, presence: true, inclusion: {in: reasons.keys}
  validates :body, presence: true, allow_blank: false

  scope :interest_in_premium_plan, -> { where(meta: {interest_in_premium_plan: true}) }
end
