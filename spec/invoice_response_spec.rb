require 'spec_helper'

describe Collector::InvoiceResponse do
  let (:raw_invoice_reponse_hash) {
    {:add_invoice_response_v31=>{:available_reservation_amount=>"0",
                                :correlation_id=>nil,
                                :due_date=>nil,
                                :invoice_no=>"125423",
                                :invoice_status=>"1",
                                :invoice_url=>nil,
                                :lowest_amount_to_pay=>nil,
                                :payment_reference=>nil,
                                :total_amount=>nil,
                                :@xmlns=>"http://schemas.ecommerce.collector.se/v30/InvoiceService"}
    }
  }
  it "can be constructed from a hash" do
    inv_resp = Collector::InvoiceResponse.new( raw_invoice_reponse_hash[:add_invoice_response_v31] )
    inv_resp.available_reservation_amount.should eq "0"
    inv_resp.correlation_id.should eq nil
    inv_resp.due_date.should eq nil
    inv_resp.invoice_no.should eq "125423"
    inv_resp.invoice_status.should eq "1"
    inv_resp.lowest_amount_to_pay.should eq nil
    inv_resp.payment_reference.should eq nil
    inv_resp.total_amount.should eq nil
  end

end