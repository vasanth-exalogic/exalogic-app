class CreatePercentages < ActiveRecord::Migration[6.0]
  def change
    create_table :percentages do |t|
      t.numeric :hra_per, :default => 0.0
      t.numeric :cca_per, :default => 0.0
      t.numeric :spl_all_per, :default => 0.0
      t.numeric :trans_all_per, :default => 0.0

      t.timestamps
    end
  end
end
