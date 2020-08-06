class Backup < ApplicationRecord
  belongs_to :user

  enum states: {
    started: 0, 
    working: 1, 
    failed:  2,
    done:    3
  }

  default_scope { order(created_at: :desc) }
end
