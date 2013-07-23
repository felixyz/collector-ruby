require 'spec_helper'

describe Collector::InvoiceRow do
  let (:invoice_row_hash) {
    { "article_id" => "123",
      "description" => "A fine piece",
      "quantity" => "23",
      "unit_price" => "12.50",
      "vat" => "3.40"
    }
  }
  it "can be constructed from a hash" do
    invoice_row = Collector::InvoiceRow.new( invoice_row_hash )
    invoice_row.article_id.should eq "123"
    invoice_row.description.should eq "A fine piece"
    invoice_row.quantity.should eq "23"
    invoice_row.unit_price.should eq "12.50"
    invoice_row.vat.should eq "3.40"
  end

  it "converts to hash and back without losing information" do
    obj = Collector::InvoiceRow.new( invoice_row_hash )
    hash = Collector::InvoiceRowRepresenter.new(obj).to_hash
    obj2 = Collector::InvoiceRow.new
    Collector::InvoiceRowRepresenter.new(obj2).from_hash(hash)
    obj2.should eq obj
  end

end