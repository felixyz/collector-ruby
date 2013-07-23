# encoding: utf-8

# Run with: bundle exec ruby ./usage_example.rb

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

user_name = 'blingo_test'
password = 'blingo_test'

collector = Collector.new(user_name, password)
response = collector.add_invoice(invoice_request)
puts "RESPONSE: #{response.inspect}"