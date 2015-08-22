class AddCcidToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :ccid, :string
  end
end
