class InvoicePdf
  attr_reader :invoice, :user

  def initialize(user, invoice)
    @user = user
    @invoice = invoice
  end

  def export
    pdftk = PdfForms.new('/usr/local/bin/pdftk')
    pdftk.get_field_names 'templates/cc-template.pdf'

    # hrs = [50.0, 60.0]
    hrs = self.invoice.work_weeks.map{|ww| ww.hours or 0.0}
    # hrs = self.invoice.work_weeks.inject(0.0){|a,b| a += b}

    # rate = 57.50
    rate = user.pay_rate

    self.invoice.calculate_totals(rate)

    invoice_prefix_seq = self.invoice.id.to_s.rjust(5, '0')
    invoice_suffix = self.invoice.invoiced_at.to_time.strftime("%Y-%m-%d")
    invoice_filename = "pdftks/CC#{invoice_prefix_seq}-#{invoice_suffix}.pdf"

    pdftk.fill_form 'templates/cc-template.pdf', invoice_filename, 
      {date: self.invoice.invoiced_at.strftime("%b %d, %Y"), 

       w1_notes: self.invoice.work_weeks[0].notes, 
       w1_hours: hrs[0].to_s, 
       w1_rate: rate.to_s, 
       w1_cost: (hrs[0] * rate).to_s, 

       w2_notes: self.invoice.work_weeks[1].notes, 
       w2_hours: hrs[1].to_s, 
       w2_rate: rate.to_s, 
       w2_cost: (hrs[1] * rate).to_s, 

       subtotal: self.invoice.subtotal.to_s, 
       tax: '0.00', 
       total: self.invoice.total.to_s, 
       invoice_notes: self.invoice.notes}

    #`./scripts/cleanup.sh #{invoice_filename}`
      #

    # output_path = output_file_path || "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf" # make sure tmp/pdfs exists
    "#{Rails.root}/#{invoice_filename}"
  end
end
