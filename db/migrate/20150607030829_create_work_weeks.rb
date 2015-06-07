class CreateWorkWeeks < ActiveRecord::Migration
  def change
    create_table :work_weeks do |t|
      t.date :started_at
      t.date :ended_at
      t.text :notes
      t.float :hours
      t.integer :invoice_id

      t.timestamps null: false
    end
  end
end
