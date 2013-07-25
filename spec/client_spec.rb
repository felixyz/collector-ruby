require 'spec_helper'
require 'vcr'
require 'webmock/rspec'
require 'nori'  # Available through Savon

describe Collector::Client do
  before :all do
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

  context "incomplete request" do
    it "raises an exception" do
      @incomplete_req = sandbox_invoice_request
      @incomplete_req.activation_option = nil
      @incomplete_req.store_id = nil
      expect { @client.add_invoice(@incomplete_req)}.to raise_error ArgumentError
    end
    it "raises an exception when nested objects are incomplete" do
      @incomplete_req = sandbox_invoice_request
      @incomplete_req.delivery_address.address1 = nil
      expect { @client.add_invoice(@incomplete_req)}.to raise_error ArgumentError
    end
    it "lists the missing attributes" do
      @incomplete_req = sandbox_invoice_request
      @incomplete_req.activation_option = nil
      @incomplete_req.delivery_address.address1 = nil
      @incomplete_req.invoice_rows.first.article_id = nil
      begin
        @client.add_invoice(@incomplete_req)
      rescue => e
        e.message.should eq "Missing attributes: activation_option, delivery_address.address1, invoice_rows[0].article_id"
      end
    end
  end
  context "SOAP query" do
    before :each do
      WebMock.after_request do |request_signature, response|
        @req_headers = request_signature.headers
        @req_body = request_signature.body
        soap = Nori.new.parse(@req_body)
        envelope = soap['env:Envelope']
        @soap_header = envelope['env:Header']
        @soap_body = envelope['env:Body']
        @soap_request = @soap_body['lol0:AddInvoiceRequest']
      end
      VCR.use_cassette('add_invoice') do
        @client.add_invoice(sandbox_invoice_request)
      end
    end

    it "sets the headers" do
      @soap_header['lol0:Password'].should eq "blingo_test"
      @soap_header['lol0:Username'].should eq "blingo_test"
      # @soap_header['lol0:ClientIpAddress'].should eq
    end

    it "includes all parameters in request" do
      @soap_request['lol0:ActivationOption'].should eq "0"
      @soap_request['lol0:CountryCode'].should eq "SE"
      @soap_request['lol0:Currency'].should eq "SEK"
      @soap_request['lol0:InvoiceDeliveryMethod'].should eq "1"
      @soap_request['lol0:InvoiceType'].should eq "0"
      @soap_request['lol0:RegNo'].should eq "1602079954"
      @soap_request['lol0:StoreId'].should eq "355"
      @soap_request['lol0:OrderDate'].should be_kind_of DateTime
      @soap_request['lol0:OrderDate'].to_time.to_f.should be_within(1).of(DateTime.now.to_time.to_f)
    end

    it "includes the DeliveryAddress" do
      @address = @soap_request['lol0:DeliveryAddress']
      @address['lol0:Address1'].should      eq    'GATUADRESSAKT211'
      @address['lol0:City'].should          eq    'UMEÅ'
      @address['lol0:CountryCode'].should   eq    'SE'
      @address['lol0:PostalCode'].should    eq    '90737'
      @address['lol0:Firstname'].should     eq    'FÖRNAMNAKT211'
      @address['lol0:Lastname'].should      eq    'EFTERNAMNAKT211'
    end

    it "includes the InvoiceAddress" do
      @address = @soap_request['lol0:InvoiceAddress']
      @address['lol0:Address1'].should      eq    'GATUADRESSAKT211'
      @address['lol0:City'].should          eq    'UMEÅ'
      @address['lol0:CountryCode'].should   eq    'SE'
      @address['lol0:PostalCode'].should    eq    '90737'
      @address['lol0:Firstname'].should     eq    'FÖRNAMNAKT211'
      @address['lol0:Lastname'].should      eq    'EFTERNAMNAKT211'
    end

    it "includes the InvoiceRows" do
      @invoice_rows = @soap_request['lol0:InvoiceRows']
      @invoice_row = @invoice_rows['lol0:InvoiceRow']
      @invoice_row['lol0:ArticleId'].should     eq    '12'
      @invoice_row['lol0:Description'].should   eq    'A wonderful thing'
      @invoice_row['lol0:Quantity'].should      eq    '2'
      @invoice_row['lol0:UnitPrice'].should     eq    '12.0'
      @invoice_row['lol0:VAT'].should          eq    '2.0'
    end

  end
end