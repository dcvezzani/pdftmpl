module FillablePdfForm

  attr_writer :template_path
  attr_reader :attributes

  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods    
  end

  module ClassMethods
  end

  module InstanceMethods
    def export(output_file_path=nil)
      output_path = output_file_path || default_output_path
      pdftk.fill_form template_path, output_path, attributes
      output_path
    end

    def get_field_names 
      pdftk.get_field_names template_path
    end

    def default_output_path(filename=SecureRandom.uuid)
      "#{Rails.root}/tmp/#{filename}.pdf" # make sure tmp/pdfs exists
    end

    def template_path
      @template_path ||= "#{Rails.root}/lib/pdf_templates/#{self.class.name.gsub('Pdf', '').underscore}.pdf" # makes assumption about template file path unless otherwise specified
    end

    protected

    def attributes
      @attributes ||= {}
    end

    def fill(key, value)
      attributes[key.to_s] = value
    end

    def pdftk
      # @pdftk ||= PdfForms.new(ENV['PDFTK_PATH'] || "#{Rails.root}/vendor/pdftk/bin/pdftk") # On my Mac, the location of pdftk was different than on my linux server.
      @pdftk ||= PdfForms.new(ENV['PDFTK_PATH'] || "/usr/local/bin/pdftk") # On my Mac, the location of pdftk was different than on my linux server.
    end

    def fill_out
      raise 'Must be overridden by child class'
    end
  end
end
