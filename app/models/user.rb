class User < ApplicationRecord
  has_secure_password
  has_one :detail
  validates_uniqueness_of :email
end
