class Payslip < ApplicationRecord
  validates_uniqueness_of :pay_id
end
