class AnonymousInquiry < ApplicationRecord

  enum reason: Inquiry.reasons

  validates :reason, presence: true, inclusion: {in: reasons.keys}
  validates :body, presence: true, allow_blank: false
  validates :email, presence: true, allow_blank: false, 'valid_email_2/email': { mx: true, disposable: true }
  
end
