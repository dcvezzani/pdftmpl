class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :invoiced_at
      t.float :subtotal
      t.float :total
      t.text :notes

      t.timestamps null: false
    end
  end
end
