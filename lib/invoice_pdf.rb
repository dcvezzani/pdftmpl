class InvoicePdf
  attr_reader :invoice, :user
  #CC_TEMPLATE = 'templates/cc-template-02.pdf'
  # CC_TEMPLATE = 'templates/cc-template-04.pdf'
  CC_TEMPLATE = 'templates/cc-template-04b.pdf'

  def initialize(user, invoice)
    @user = user
    @invoice = invoice
  end

  def number_with_precision(number, options = {precision: 2})
    #{"%.0#{options[:precision]}f" % number}
    ("%.#{options[:precision]}f" % number)
  end

  def export_02
    # pdf_template = IO.read(CC_TEMPLATE)
    pdf_template = File.open(CC_TEMPLATE, "r:UTF-8", &:read)
    # pdf_template = "alsdkjl askdjl askdj lasdjk {invoice_notes} alsdk laskd jlaks djlkjas"
    values = prepare_values
    invoice_filename = values[:invoice_filename]
    # pdf_template.force_encoding('UTF-8')

    {
      date: values[:date], 

      w1_notes: values[:w1_notes], 
      w1_hours: number_with_precision(values[:w1_hours], :precision => 2).to_s, 
      w1_rate: number_with_precision(values[:w1_rate], :precision => 2).to_s, 
      w1_cost: number_with_precision(values[:w1_cost], :precision => 2).to_s, 

      w2_notes: values[:w2_notes], 
      w2_hours: number_with_precision(values[:w2_hours], :precision => 2).to_s, 
      w2_rate: number_with_precision(values[:w2_rate], :precision => 2).to_s, 
      w2_cost: number_with_precision(values[:w2_cost], :precision => 2).to_s, 

      subtotal: number_with_precision(values[:subtotal], :precision => 2).to_s, 
      tax: number_with_precision(values[:tax], :precision => 2).to_s, 
      total: number_with_precision(values[:total], :precision => 2).to_s, 

      invoice_notes: values[:invoice_notes], 
      invoice_number: values[:invoice_number]
    }.each do |attr, value|
      term = "{#{attr.to_s}}"
      # term = "{invoice_notes}"; value = 'Efrén'
      fnd = pdf_template.index(term)
      _before = pdf_template[0, fnd]
      # pdf_template[fnd, term.length]
      _after = pdf_template[fnd+term.length, (pdf_template.length - fnd+term.length)]
      pdf_template = _before + value + _after
      
      # pdf_template.sub!(Regexp.new("{#{attr.to_s}}"), value)
    end

    {filename: invoice_filename, body: pdf_template}
  end

  def value_with_special_characters(value)
    new_value = "(þÿ"
    value.split(//).each do |c|
      new_value += '\000' + c
    end
    new_value += ")"
  end

  def export
    pdftk = PdfForms.new('/usr/local/bin/pdftk')
    pdftk.get_field_names CC_TEMPLATE

    values = prepare_values
    invoice_filename = values[:invoice_filename]

    pdftk.fill_form CC_TEMPLATE, invoice_filename, 
      {
        date: values[:date], 

        w1_notes: values[:w1_notes], 
        w1_hours: number_with_precision(values[:w1_hours], :precision => 2).to_s, 
        w1_rate: number_with_precision(values[:w1_rate], :precision => 2).to_s, 
        w1_cost: number_with_precision(values[:w1_cost], :precision => 2).to_s, 
 
        w2_notes: values[:w2_notes], 
        w2_hours: number_with_precision(values[:w2_hours], :precision => 2).to_s, 
        w2_rate: number_with_precision(values[:w2_rate], :precision => 2).to_s, 
        w2_cost: number_with_precision(values[:w2_cost], :precision => 2).to_s, 

        subtotal: number_with_precision(values[:subtotal], :precision => 2).to_s, 
        tax: number_with_precision(values[:tax], :precision => 2).to_s, 
        total: number_with_precision(values[:total], :precision => 2).to_s, 

        invoice_notes: values[:invoice_notes], 
        invoice_number: values[:invoice_number]
      }

    `./scripts/cleanup.sh #{invoice_filename}`

    # output_path = output_file_path || "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf" # make sure tmp/pdfs exists
    {filename: "#{Rails.root}/#{invoice_filename}", body: nil}
  end

  def prepare_values
    hrs = self.invoice.work_weeks.map{|ww| ww.hours or 0.0}
    # hrs = [50.0, 60.0]
    # hrs = self.invoice.work_weeks.inject(0.0){|a,b| a += b}

    rate = user.pay_rate
    self.invoice.calculate_totals(rate)

    invoice_prefix_seq = self.invoice.id.to_s.rjust(5, '0')
    invoice_suffix = self.invoice.invoiced_at.to_time.strftime("%Y-%m-%d")
    invoice_number = "CC#{invoice_prefix_seq}"
    invoice_filename = "pdftks/#{invoice_number}-#{invoice_suffix}.pdf"
    
    {
     date: self.invoice.invoiced_at.strftime("%b %d, %Y"), 

     w1_notes: self.invoice.work_weeks[0].notes, 
     w1_hours: hrs[0], 
     w1_rate: rate, 
     w1_cost: (hrs[0] * rate), 

     w2_notes: self.invoice.work_weeks[1].notes, 
     w2_hours: hrs[1], 
     w2_rate: rate, 
     w2_cost: (hrs[1] * rate), 

     subtotal: self.invoice.subtotal, 
     tax: 0.0, 
     total: self.invoice.total, 

     invoice_notes: self.invoice.notes, 
     invoice_number: invoice_number, 
     invoice_filename: invoice_filename
    }
  end
  
end
