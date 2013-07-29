require 'spec_helper'
require 'vcr'

describe "Collector::Client" do
  # TODO: Should be a shared example, but hard to make it fit
  def spec_correct_response(response)
    response.should be_kind_of Collector::InvoiceResponse
    response.payment_reference.should_not be_nil
    # TODO: What does this depend on?
    response.lowest_amount_to_pay.should eq "50.00"
    expected_due_date = (Time.now + 180*24*60*60).to_f
    response.due_date.to_time.to_f.should be_within(24*60*60).of(expected_due_date)
    response.invoice_url.should match %r(https://commerce.collector.se/testportal/PdfInvoice\?pnr=(\d+)\&invnr=#{@invoice_no})
  end

  before :each do
    @client = collector_client
  end

  context "#activate_invoice" do

    it "performs an ActivateInvoice request" do
      VCR.use_cassette('activate_invoice') do
        @invoice_no = add_original_invoice
        response = @client.activate_invoice(invoice_no: @invoice_no,
                                            store_id: "355",
                                            country_code: "SE",
                                            correlation_id: "testing_activate_invoice")
        spec_correct_response(response)
        response.correlation_id.should eq "testing_activate_invoice"
        total_price = [product1, product2, product3].reduce(0){|memo, p| memo += (p.unit_price * p.quantity) }
        response.total_amount.to_f.should eq total_price
      end
    end
  end # #activate_invoice
  context "#part_activate_invoice" do
    def part_activate
      @product = product2
      @item = Collector::ArticleListItem.new(@product)
      @response = @client.part_activate_invoice(
                      invoice_no: @invoice_no,
                        store_id: "355",
                    country_code: "SE",
                  correlation_id: "testing_part_activate_invoice",
                    article_list: [@item])
    end
    it "requires the article_list parameter" do
      VCR.use_cassette('part_activate_invoice', :record => :new_episodes) { @invoice_no = add_original_invoice }
      expect {
          @client.part_activate_invoice(invoice_no: @invoice_no, store_id: "355", country_code: "SE")
        }.to raise_error ArgumentError
    end
    it "performs a PartActivateInvoice request" do
      VCR.use_cassette('part_activate_invoice', :record => :new_episodes) do
        @invoice_no = add_original_invoice
        part_activate
        spec_correct_response(@response)
        @response.correlation_id.should eq "testing_part_activate_invoice"
        @response.total_amount.to_f.should eq (@product.unit_price * @item.quantity)
      end
    end
    it "returns the new invoice number" do
      VCR.use_cassette('part_activate_invoice', :record => :new_episodes) do
        @invoice_no = add_original_invoice
        part_activate
        @response.new_invoice_no.should_not be_nil
      end
      VCR.use_cassette('activate_remainder_invoice') do
        @invoice_no = @response.new_invoice_no
        new_resp = @client.activate_invoice(invoice_no: @invoice_no,
                                              store_id: "355",
                                          country_code: "SE",
                                        correlation_id: "testing_remainder_activate_invoice")
        spec_correct_response(new_resp)
        new_resp.correlation_id.should eq "testing_remainder_activate_invoice"
        total_price = [product1, product2, product3].reduce(0){|memo, p| memo += (p.unit_price * p.quantity) }
        activated_amount = @product.unit_price * @item.quantity
        new_resp.total_amount.to_f.should eq total_price - activated_amount
      end
    end
  end # #part_activate_invoice
end