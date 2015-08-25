class PdfController < ApplicationController
  def show
    record = PdfRecord.first
    respond_to do |format|
      format.pdf { send_file TestPdfForm.new(record).export, type: 'application/pdf' }
    end
  end
end
