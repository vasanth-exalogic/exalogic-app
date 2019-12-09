class Detail < ApplicationRecord
  belongs_to :user
  validates :fname, format: {with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/}
  validates :lname, format: {with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/}
  validates :gender, presence: true
end
