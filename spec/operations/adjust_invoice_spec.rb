require 'spec_helper'
require 'vcr'

describe 'Collector::Client#adjust_invoice' do
  before :each do
    @client = collector_client
    product = product2
    @item = Collector::ArticleListItem.new(product)
  end
  def activate_invoice(invoice_no)
    @client.activate_invoice(invoice_no: invoice_no,
                             store_id: '355',
                             country_code: 'SE',
                             correlation_id: 'testing_activate_invoice')
  end

  def adjust_invoice(invoice_no, item, amount, vat)
    @client.adjust_invoice(invoice_no: invoice_no,
                           article_id: item.article_id,
                           description: 'You are our 100th customer!',
                           amount: amount,
                           vat: vat,
                           store_id: '355',
                           country_code: 'SE',
                           correlation_id: 'testing_adjust_invoice')
  end
  it 'performs an AdjustInvoice request' do
    VCR.use_cassette('adjust_invoice') do
      invoice_no = add_original_invoice
      activate_invoice(invoice_no)
      amount = '-2.50'
      vat = '2.0'
      correlation_id = adjust_invoice(invoice_no, @item, amount, vat)
      correlation_id.should eq 'testing_adjust_invoice'
    end
  end
  it 'it allows adjusting back to the original amount' do
    VCR.use_cassette('adjust_invoice_back') do
      invoice_no = add_original_invoice
      activate_invoice(invoice_no)
      adjust_invoice(invoice_no, @item, '-2.50', '2.0')
      adjust_invoice(invoice_no, @item, '-1.50', '2.0')
      expect { adjust_invoice(invoice_no, @item, '4.00', '2.0') }.not_to raise_error
    end
  end
  xit 'it does not allow adjusting back to more than the original amount' do
    VCR.use_cassette('adjust_invoice_back_too_much') do
      invoice_no = add_original_invoice
      activate_invoice(invoice_no)
      adjust_invoice(invoice_no, @item, '-2.50', '2.0')
      adjust_invoice(invoice_no, @item, '-1.50', '2.0')
      expect { adjust_invoice(invoice_no, @item, '4.50', '2.0') }.to raise_error Collector::InvalidTransactionAmountError
    end
  end
end
