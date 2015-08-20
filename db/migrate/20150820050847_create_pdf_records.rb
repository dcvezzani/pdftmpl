class CreatePdfRecords < ActiveRecord::Migration
  def change
    create_table :pdf_records do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.integer :age
      t.text :comments

      t.timestamps null: false
    end
  end
end
