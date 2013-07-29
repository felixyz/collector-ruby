require 'spec_helper'
require 'vcr'

describe "Collector::Client#cancel_invoice" do
  before :all do
    @client = collector_client
  end
  def cancel_invoice(invoice_no)
    @client.cancel_invoice(invoice_no: invoice_no,
                             store_id: "355",
                         country_code: "SE",
                       correlation_id: "test_cancel_invoice" )

  end
  it "performs a CancelInvoice request" do
    VCR.use_cassette('cancel_invoice') do
      @invoice_no = add_original_invoice
      correlation_id = cancel_invoice(@invoice_no)
      correlation_id.should eq "test_cancel_invoice"
      expect { cancel_invoice(@invoice_no) }.to raise_error Collector::InvalidInvoiceStatusError
    end
  end
  it "causes the invoice to be impossible to activate" do
    VCR.use_cassette('activate_canceled_invoice') do
      @invoice_no = add_original_invoice
      cancel_invoice(@invoice_no)
      expect { @client.activate_invoice(invoice_no: @invoice_no,
                                          store_id: "355",
                                          country_code: "SE")
      }.to raise_error Collector::InvoiceNotFoundError
      end
    end
end