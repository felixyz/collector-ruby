# Collector::Ruby

This gem provides an interface to the Collector API.

__Important__: The gem depends on the unfinished version 3 of Savon, and therefore users of this gem must also include this in their Gemfile:

    gem 'savon', :github => "savonrb/savon", :branch => "master"


## Installation

Add this line to your application's Gemfile:

    gem 'collector-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collector-ruby

## Usage

	require 'collector'
	
	address = Collector::Address.new(
	            address1: "GATUADRESSAKT211",
	            city: "UMEÅ",
	            country_code: "SE",
	            postal_code: "90737",
	            first_name: "FÖRNAMNAKT211",
	            last_name: "EFTERNAMNAKT211" )
	
	invoice_row = Collector::InvoiceRow.new(
	                article_id: 12,
	                description: "A wonderful thing",
	                quantity: "2",
	                unit_price: 12.0,
	                vat: 2.0 )
	
	invoice_request = Collector::InvoiceRequest.new(activation_option: 0,
	                    country_code: "SE",
	                    currency: "SEK",
	                    delivery_address: address,
	                    invoice_address: address,
	                    invoice_delivery_method: 1,
	                    invoice_rows: [invoice_row],
	                    invoice_type: 0,
	                    order_date: DateTime.now,
	                    reg_no: "1602079954",
	                    store_id: "355" )
	
	user_name = "" # Your Collector user name
	password = "" # Your Collector password
	
	collector = Collector.new(user_name, password)
	response = collector.add_invoice(invoice_request)

	puts "Response: #{response.inspect}"
	# => <Collector::AddInvoiceResponse:0x007f9c358c13c8 @available_reservation_amount="0", @correlation_id=nil, @due_date=nil, @invoice_no="125434", @invoice_status="1", @invoice_url=nil, @lowest_amount_to_pay=nil, @payment_reference=nil, @total_amount=nil>