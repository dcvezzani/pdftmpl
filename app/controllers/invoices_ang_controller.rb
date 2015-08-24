class InvoicesAngController < ApplicationController
  before_action :set_invoice, only: [:show, :report, :edit, :calc, :update, :destroy]
  before_action :deserialize_dates, only: [:create, :update]
  skip_before_filter :verify_authenticity_token

  def index
    @invoices = if params[:keywords]
                 Invoice.where('lower(name) like ?',"%#{params[:keywords]}%")
               else
                 Invoice.all
               end
  end

  def show
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.save
    render 'show', status: 201
  end

  def update
    @invoice.update_attributes(invoice_params)
    head :no_content
  end

  def destroy
    @invoice.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoices_ang).permit(:invoiced_at, :subtotal, :total, :notes, :ccid, :invoiced_at_1i, :invoiced_at_2i, :invoiced_at_3i)
    end

    def deserialize_dates
      form = params[:invoices_ang]
      form[:invoiced_at] = "#{form[:invoiced_at_1i]}-#{form[:invoiced_at_2i]}-#{form[:invoiced_at_3i]}"
      params[:invoices_ang].except! :invoiced_at_1i, :invoiced_at_2i, :invoiced_at_3i
    end
end
