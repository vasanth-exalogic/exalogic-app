class CreatePayslips < ActiveRecord::Migration[6.0]
  def change
    create_table :payslips do |t|
      t.numeric :pay_id, :default => 0.0
      t.numeric :basic, :default => 0.0
      t.numeric :hra, :default => 0.0
      t.numeric :cca, :default => 0.0
      t.numeric :spl_all, :default => 0.0
      t.numeric :trans_all, :default => 0.0
      t.numeric :reimb, :default => 0.0
      t.numeric :lop, :default => 0.0
      t.numeric :deduction, :default => 0.0
      t.numeric :p_tax, :default => 0.0
      t.numeric :gross, :default => 0.0
      t.numeric :net, :default => 0.0
      t.numeric :ctc, :default => 0.0
      t.integer :days, :default => 0
      t.string :user_id

      t.timestamps
    end
  end
end
