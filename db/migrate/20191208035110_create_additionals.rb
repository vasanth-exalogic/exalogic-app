class CreateAdditionals < ActiveRecord::Migration[6.0]
  def change
    create_table :additionals do |t|
      t.string :ename
      t.string :econtact
      t.string :relation
      t.string :pskill
      t.string :sskill1
      t.string :sskill2
      t.string :user_id

      t.timestamps
    end
  end
end
