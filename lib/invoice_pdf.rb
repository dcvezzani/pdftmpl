class InvoicePdf
  attr_reader :invoice, :user
  #CC_TEMPLATE = 'templates/cc-template-02.pdf'
  CC_TEMPLATE = 'templates/cc-template-04.pdf'

  def initialize(user, invoice)
    @user = user
    @invoice = invoice
  end

  def number_with_precision(number, options = {precision: 2})
    #{"%.0#{options[:precision]}f" % number}
    ("%.#{options[:precision]}f" % number)
  end

  def export
    pdftk = PdfForms.new('/usr/local/bin/pdftk')
    pdftk.get_field_names CC_TEMPLATE

    # hrs = [50.0, 60.0]
    hrs = self.invoice.work_weeks.map{|ww| ww.hours or 0.0}
    # hrs = self.invoice.work_weeks.inject(0.0){|a,b| a += b}

    # rate = 57.50
    rate = user.pay_rate

    self.invoice.calculate_totals(rate)

    invoice_prefix_seq = self.invoice.id.to_s.rjust(5, '0')
    invoice_suffix = self.invoice.invoiced_at.to_time.strftime("%Y-%m-%d")
    invoice_number = "CC#{invoice_prefix_seq}"
    invoice_filename = "pdftks/#{invoice_number}-#{invoice_suffix}.pdf"

    pdftk.fill_form CC_TEMPLATE, invoice_filename, 
      {date: self.invoice.invoiced_at.strftime("%b %d, %Y"), 

       w1_notes: self.invoice.work_weeks[0].notes, 
       w1_hours: hrs[0].to_s, 
       w1_rate: number_with_precision(rate.to_s, :precision => 2).to_s,
       w1_cost: number_with_precision(hrs[0] * rate, :precision => 2).to_s, 

       w2_notes: self.invoice.work_weeks[1].notes, 
       w2_hours: hrs[1].to_s, 
       w2_rate: number_with_precision(rate.to_s, :precision => 2).to_s,
       w2_cost: number_with_precision(hrs[1] * rate, :precision => 2).to_s, 

       subtotal: number_with_precision(self.invoice.subtotal, :precision => 2).to_s, 
       tax: '0.00', 
       total: number_with_precision(self.invoice.total, :precision => 2).to_s, 
       invoice_notes: self.invoice.notes, 
       invoice_number: invoice_number}

    `./scripts/cleanup.sh #{invoice_filename}`
      #

    # output_path = output_file_path || "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf" # make sure tmp/pdfs exists
    "#{Rails.root}/#{invoice_filename}"
  end
end
