require 'spec_helper'
require 'vcr'

describe "Collector::Client#activate_invoice" do
  before :all do
    @client = collector_client
    VCR.use_cassette('add_invoice') do
      response = @client.add_invoice(sandbox_invoice_request)
      @invoice_no = response.invoice_no
    end
  end
  it "performs an ActivateInvoice request" do
    VCR.use_cassette('activate_invoice') do
      response = @client.activate_invoice(invoice_no: @invoice_no,
                                          store_id: "355",
                                          country_code: "SE",
                                          correlation_id: "testing_activate_invoice")
      response.should be_kind_of Collector::InvoiceResponse
      response.correlation_id.should eq "testing_activate_invoice"
      response.payment_reference.should_not be_nil
      response.lowest_amount_to_pay.should eq "24.00"
      response.total_amount.should eq "24.00"
      expected_due_date = (Time.now + 180*24*60*60).to_f
      response.due_date.to_time.to_f.should be_within(24*60*60).of(expected_due_date)
      response.invoice_url.should match %r(https://commerce.collector.se/testportal/PdfInvoice\?pnr=(\d+)\&invnr=#{@invoice_no})
    end
  end
end