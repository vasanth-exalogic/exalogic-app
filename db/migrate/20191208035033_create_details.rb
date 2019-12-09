class CreateDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :details do |t|
      t.string :fname
      t.string :lname
      t.date :dob
      t.date :doj
      t.string :department
      t.string :designation
      t.string :contact
      t.string :bloodgroup
      t.string :gender
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.string :empid
      t.string :user_id

      t.timestamps
    end
  end
end
