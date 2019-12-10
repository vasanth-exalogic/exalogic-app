class AddNoDaysToPayslips < ActiveRecord::Migration[6.0]
  def change
    add_column :payslips, :no_days, :integer, :default => 0
  end
end
