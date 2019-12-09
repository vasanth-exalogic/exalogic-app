class AddMonthToPayslips < ActiveRecord::Migration[6.0]
  def change
    add_column :payslips, :month, :integer
    add_column :payslips, :year, :integer
  end
end
