# encoding: utf-8

# Hashes
def sandbox_user_address_hash
  { address1: "GATUADRESSAKT211",
    city: "UMEÅ",
    country_code: "SE",
    postal_code: "90737",
    first_name: "FÖRNAMNAKT211",
    last_name: "EFTERNAMNAKT211" }
end

def sandbox_user_address
  Collector::Address.new(sandbox_user_address_hash )
end

def sandbox_invoice_row_hash
  { article_id: 12,
    description: "A wonderful thing",
    quantity: "2",
    unit_price: 12.0,
    vat: 2.0
  }
end

def sandbox_invoice_row
  Collector::InvoiceRow.new(sandbox_invoice_row_hash)
end

def sandbox_invoice_request_hash
  {  activation_option: 0,
    country_code: "SE",
    currency: "SEK",
    delivery_address: sandbox_user_address,
    invoice_address: sandbox_user_address,
    invoice_delivery_method: 1,
    invoice_rows: [sandbox_invoice_row],
    invoice_type: 0,
    order_date: DateTime.now,
    reg_no: "1602079954",
    store_id: "355" }
end

def sandbox_invoice_request
  Collector::InvoiceRequest.new(sandbox_invoice_request_hash)
end