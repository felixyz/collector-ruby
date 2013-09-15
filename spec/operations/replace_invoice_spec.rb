require 'spec_helper'
require 'vcr'

describe "Collector::Client#replace_invoice" do
  let(:new_rows) {
    [ sandbox_invoice_row(article_id: 301, unit_price: 47.5, quantity: 1),
      sandbox_invoice_row(article_id: 302, unit_price: 53.5, quantity: 2),
      sandbox_invoice_row(article_id: 303, unit_price: 101.5, quantity: 3) ]
  }
  before :each do
    @client = collector_client
    @product = product2
  end
  def activate_invoice(invoice_no)
    @client.activate_invoice(invoice_no: invoice_no,
                               store_id: "355",
                           country_code: "SE",
                         correlation_id: "testing_activate_invoice")
  end
  def replace_invoice(invoice_no, new_rows)
    @client.replace_invoice(invoice_no: invoice_no,
                             store_id: "355",
                         country_code: "SE",
                       correlation_id: "testing_replace_invoice",
                         invoice_rows: new_rows)
  end
  it "performs a ReplaceInvoice request" do
    VCR.use_cassette('replace_invoice') do
      invoice_no = add_original_invoice
      # activate_invoice(invoice_no)
      response = replace_invoice(invoice_no, new_rows)
      response.correlation_id.should eq "testing_replace_invoice"
      response.total_amount.to_f.should eq new_rows.inject(0) { |acc, row|
        acc + row.unit_price * row.quantity
      }
      response.invoice_status.to_i.should eq 1
    end
  end
  it "doesn't perform a ReplaceInvoice request for an activated invoice" do
    VCR.use_cassette('replace_activated_invoice') do
      invoice_no = add_original_invoice
      activate_invoice(invoice_no)
      expect { replace_invoice(invoice_no, new_rows) }.to raise_error Collector::InvalidInvoiceStatusError
    end
  end
end