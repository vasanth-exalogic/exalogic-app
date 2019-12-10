class ChangeNoticeToBeIntegerInAdditionals < ActiveRecord::Migration[6.0]
  def change
    change_column :additionals, :notice, :integer, :default=>0
  end
end
