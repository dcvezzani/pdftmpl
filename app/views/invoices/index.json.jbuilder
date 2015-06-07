json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :invoiced_at, :subtotal, :total, :notes
  json.url invoice_url(invoice, format: :json)
end
