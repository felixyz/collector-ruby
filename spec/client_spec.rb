require 'spec_helper'
require 'vcr'

describe Collector::Client do
  before :each do
    user_name = 'blingo_test'
    password = 'blingo_test'
    VCR.use_cassette('create_client') do
      @client = Collector.new(user_name, password)
    end
  end

  it "performs an AddInvoice request" do
    VCR.use_cassette('add_invoice') do
      response = @client.add_invoice(sandbox_invoice_request)
      response.should be_kind_of Collector::AddInvoiceResponse
      response.invoice_no.should_not be_nil
      response.invoice_status.should_not be_nil
    end
  end
end