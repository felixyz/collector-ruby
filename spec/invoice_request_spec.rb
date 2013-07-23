require 'spec_helper'

describe Collector::InvoiceRequest do
  let (:invoice_req_hash) { sandbox_invoice_request_hash }

  it "can be constructed from a hash" do
    invoice_req = Collector::InvoiceRequest.new( invoice_req_hash )
    invoice_req_hash.each do |key, val|
      invoice_req.send(key).should eq val
    end
  end

  it "compares objects" do
    invoice_req1 = Collector::InvoiceRequest.new( invoice_req_hash )
    invoice_req2 = Collector::InvoiceRequest.new( invoice_req_hash )
    invoice_req1.should eq invoice_req2
  end

  it "converts to hash and back without losing information" do
    obj = sandbox_invoice_request
    hash = Collector::InvoiceRequestRepresenter.new(obj).to_hash
    obj2 = Collector::InvoiceRequest.new
    Collector::InvoiceRequestRepresenter.new(obj2).from_hash(hash)
    obj2.should eq obj
  end

end