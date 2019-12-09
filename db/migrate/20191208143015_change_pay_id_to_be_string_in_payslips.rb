class ChangePayIdToBeStringInPayslips < ActiveRecord::Migration[6.0]
  def change
    change_column :payslips, :pay_id, :string
  end
end
