# Collector::Ruby

This gem provides an interface to the Collector API.

__Important__: `collector-ruby` depends on the unfinished version 3 of Savon, and therefore users of this gem must also include this in their Gemfile:

    gem 'savon', :github => "savonrb/savon", :branch => "master"


## Installation

Add this line to your application's Gemfile:

    gem 'collector-ruby', :github => "blingo/collector-ruby", :branch => "master"

And then execute:

    $ bundle

# Usage
## Initializing the client
All calls to the Collector API are performed by instances of the `Collector::Client` class. The client has no state apart from the configuration parameters passed when initializing it. The initializer requires the user name and password, and an optional third parameter specifies whether to use the sandbox environment.

	regular_client = Collector.new(user_name, password)
	sandbox_client = Collector.new(user_name, password, true)

## Add Invoice

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

## Activate Invoice
These methods return instances of `Collector::InvoiceResponse`, which has the the following attributes:
`:available_reservation_amount, :correlation_id,`
`:due_date, :invoice_no, :invoice_status, :invoice_url,`
`:lowest_amount_to_pay, :payment_reference, :total_amount,`
`:new_invoice_no`

(`:new_invoice_no` is only returned when partially activating an invoice.)


### Full Activation
    response = @client.activate_invoice(invoice_no: invoice_no,
                                            store_id: "355",
                                            country_code: "SE",
                                            correlation_id: "optional_unique_string")



### Part Activation
Part activation of an invoice can be performed either by calling the same `#activate_invoice` method as for full activation, but including `article_list` among the parameters, or more explicitly by calling `#part_activate_invoice`.

Whichever method is used, the same parameters are expected and the response is identical. The only difference is that when `#part_activate_invoice` is called without an `article_list` parameter, an `ArgumentError` will be raised.

    item = Collector::ArticleListItem.new(article_id: 101, quantity: 1, description: "A fine piece")
    item2 = Collector::ArticleListItem.new(article_id: 102, quantity: 1, description: "Another fine piece")
    response = @client.part_activate_invoice(
                    invoice_no: invoice_no,
                      store_id: "355",
                  country_code: "SE",
                  article_list: [item, item2])

`ArticleListItem` instances can also be initialized from `InvoiceRow` objects:

    item = Collector::ArticleListItem.new(invoice_row)

## Adjust Invoice

    correlation_id = @client.adjust_invoice(invoice_no: invoice_no,
                           article_id: 101,
                          description: "You are our 100th customer!",
                               amount: "-20.0",
                                  vat: "2.0",
                             store_id: "355",
                         country_code: "SE",
                       correlation_id: "optional_unique_string")
The same invoice can be adjusted to a lower amount several times, and may also be adjusted by a positive amount, but only up to the original amount of the invoice. If an attempt is made to adjust the invoice beyond its original amount, an `InvalidTransactionAmountError` will be raised.

## Cancel Invoice
    correlation_id = @client.cancel_invoice(invoice_no: invoice_no,
                             store_id: "355",
                         country_code: "SE",
                       correlation_id: "optional_unique_string" )

Attempts to cancel an already canceled invoice will result in an `InvalidInvoiceStatusError`.

## Get Address
    user = @client.get_address(reg_no: "1602079954", store_id: "355")

The returned `User` object has the following attributes:

    :first_name, :last_name, :reg_no, :addresses

`addresses` is an array, but currently never contains at most one address. This operation is only available in Sweden, and an agreement with Collector is required for its use.