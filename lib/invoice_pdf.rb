class InvoicePdf
  include FillablePdfForm

  attr_reader :invoice, :user

  def initialize(user, invoice)
    @user = user
    @invoice = invoice
    @values = prepare_values
    record = PdfRecord.first
    @values = prepare_values
    
    fill_out
  end

  def number_with_precision(number, options = {precision: 2})
    #{"%.0#{options[:precision]}f" % number}
    (!number.nil?) ? ("%.#{options[:precision]}f" % number) : 0.00
  end

  def template_path
    @template_path ||= "#{Rails.root}/templates/cc-invoice-master-w-fields.pdf"
  end

  alias_method :export_orig, :export

  def export
    output_path = export_orig(@values[:invoice_filename])#(default_output_path)
    {filename: output_path}
  end
  

  def fill_out
    # fill :date, Date.today.to_s
    # [:first_name, :last_name, :address, :address_2, :city, :state, :zip_code].each do |field|
    #   fill field, @record.send(field)
    # end
    # fill :age, case @user.age
    #   when nil then nil
    #   when 0..17 then '0_17'
    #   when 18..34 then '18_34'
    #   when 35..54 then '35_54'
    #   else '55_plus'
    # end
    # fill :comments, "Hello, World"

    # fill :date, @values[:date].to_s
    fill :date, @values[:date]
    fill :invoice_number, @values[:invoice_number]
    fill :notes, @values[:notes]

    fill :w1_notes, @values[:w1_notes]
    fill :w1_hours, number_with_precision(@values[:w1_hours], :precision => 2).to_s
    fill :w1_rate, number_with_precision(@values[:w1_rate], :precision => 2).to_s
    fill :w1_total, number_with_precision(@values[:w1_total], :precision => 2).to_s

    fill :w2_notes, @values[:w2_notes]
    fill :w2_hours, number_with_precision(@values[:w2_hours], :precision => 2).to_s
    fill :w2_rate, number_with_precision(@values[:w2_rate], :precision => 2).to_s
    fill :w2_total, number_with_precision(@values[:w2_total], :precision => 2).to_s
 
    fill :sub_hours, number_with_precision(@values[:sub_hours], :precision => 2).to_s
    fill :sub_rate, number_with_precision(@values[:sub_rate], :precision => 2).to_s
    fill :sub_total, number_with_precision(@values[:sub_total], :precision => 2).to_s
 
    # fill :tax_rate, number_with_precision(@values[:sub_rate], :precision => 2).to_s
    # fill :tax, number_with_precision(@values[:sub_total], :precision => 2).to_s
 
    fill :total, number_with_precision(@values[:total], :precision => 2).to_s
 
# 
#       date: values[:date], 
# 
#       w1_notes: values[:w1_notes], 
#       w1_hours: number_with_precision(values[:w1_hours], :precision => 2).to_s, 
#       w1_rate: number_with_precision(values[:w1_rate], :precision => 2).to_s, 
#       w1_cost: number_with_precision(values[:w1_cost], :precision => 2).to_s, 
# 
#       w2_notes: values[:w2_notes], 
#       w2_hours: number_with_precision(values[:w2_hours], :precision => 2).to_s, 
#       w2_rate: number_with_precision(values[:w2_rate], :precision => 2).to_s, 
#       w2_cost: number_with_precision(values[:w2_cost], :precision => 2).to_s, 
# 
#       subtotal: number_with_precision(values[:subtotal], :precision => 2).to_s, 
#       tax: number_with_precision(values[:tax], :precision => 2).to_s, 
#       total: number_with_precision(values[:total], :precision => 2).to_s, 
# 
#       invoice_notes: values[:invoice_notes], 
#       invoice_number: values[:invoice_number]
    
  end


  def value_with_special_characters(value)
    new_value = "(þÿ"
    value.split(//).each do |c|
      new_value += '\000' + c
    end
    new_value += ")"
  end


  def prepare_values
    hrs = self.invoice.work_weeks.map{|ww| ww.hours or 0.0}
    # hrs = [50.0, 60.0]
    # hrs = self.invoice.work_weeks.inject(0.0){|a,b| a += b}

    rate = user.pay_rate
    self.invoice.calculate_totals(rate)

    invoice_number = self.invoice.ccid_value
    invoice_suffix = self.invoice.invoiced_at.to_time.strftime("%Y-%m-%d")
    invoice_filename = "#{invoice_number}-#{invoice_suffix}"

    w1_notes = format_work_week_notes(self.invoice.work_weeks[0].started_at, self.invoice.work_weeks[0].ended_at, self.invoice.work_weeks[0].notes)
    w2_notes = format_work_week_notes(self.invoice.work_weeks[1].started_at, self.invoice.work_weeks[1].ended_at, self.invoice.work_weeks[1].notes)

    {
     date: self.invoice.invoiced_at.strftime("%b %d, %Y"), 
     invoice_number: invoice_number, 
     # terms: '15 days', 
     # tax_rate: '0.00%', 

     w1_notes: w1_notes, 
     w1_hours: (hrs[0] or 0.0), 
     w1_rate: rate, 
     w1_total: ((hrs[0] or 0.0) * rate), 

     w2_notes: w2_notes, 
     w2_hours: (hrs[1] or 0.0), 
     w2_rate: rate, 
     w2_total: ((hrs[1] or 0.0) * rate), 

     sub_hours: hrs.inject(0.00){|a,b| a+b},
     sub_rate: rate, 
     sub_total: self.invoice.subtotal, 

     # tax: 0.0, 
     total: self.invoice.total, 

     notes: self.invoice.notes.strip.capitalize, 
     invoice_filename: invoice_filename
    }
  end

  def format_work_week_notes(start_date, end_date, notes)
    "#{format_dates(start_date, end_date)}: #{notes}"
  end

  def format_dates(start_date, end_date)
    "#{format_date(start_date)} - #{format_date(end_date)}"
  end
  
  def format_date(date)
    date.strftime("%Y-%m-%d")
  end
  
  def pdftk
    @pdftk ||= PdfForms.new(ENV['PDFTK_PATH'] || "/usr/local/bin/pdftk") # On my Mac, the location of pdftk was different than on my linux server.
  end

  def output_dir
    @output_dir ||= (ENV['PDFTK_OUTPUT_PATH'] ? ENV['PDFTK_OUTPUT_PATH'] : Rails.root('pdftks'))
  end

  
end

=begin

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

  def export
    # pdftk = PdfForms.new('/usr/local/bin/pdftk')
    # pdftk.get_field_names CC_TEMPLATE

    values = prepare_values
    invoice_filename = values[:invoice_filename]

    pdftk.fill_form CC_TEMPLATE, invoice_filename, 
      {
      }

    # `./scripts/cleanup.sh #{invoice_filename}`

    # output_path = output_file_path || "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf" # make sure tmp/pdfs exists
    {filename: "#{Rails.root}/#{invoice_filename}", body: nil}
  end

=end
