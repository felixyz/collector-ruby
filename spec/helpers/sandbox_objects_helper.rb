# encoding: utf-8

# Hashes
def sandbox_user_address_hash
  { address1: "GATUADRESSAKT211",
    address2: "Not required",
    city: "UMEÅ",
    country_code: "SE",
    postal_code: "90737",
    first_name: "FÖRNAMNAKT211",
    last_name: "EFTERNAMNAKT211" }
end

def sandbox_user_address
  Collector::Address.new(sandbox_user_address_hash )
end

def sandbox_invoice_row_hash(opts = {})
  { article_id: "12",
    description: "A wonderful thing",
    quantity: "2",
    unit_price: "12.0",
    vat: "2.0"
  }.merge(opts)
end

def sandbox_invoice_row(opts = {})
  Collector::InvoiceRow.new(sandbox_invoice_row_hash(opts))
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

def full_address_hash
  sandbox_user_address_hash.merge({
        address2: "not required",
        co_address: "not required",
        cell_phone_number: "not required",
        # company_name: "not required",   # Can't test. Sandbox user is a "private customer"
        email: "not@required.se",
        phone_number: "not required"
      })
end

def full_sandbox_address
  Collector::Address.new(full_address_hash)
end

def full_invoice_request_hash
  sandbox_invoice_request_hash.merge({
        correlation_id: "test corr id",
        cost_center: "not required",
        credit_time: 10,
        customer_no: "not required",
        delivery_address: full_sandbox_address,
        gender: 0,
        invoice_address: full_sandbox_address,
        order_no: "not required",
        # product_code: "",  # Can't test, defined by Collector, requires agreement
        purchase_type: 0,
        reference: "not required",
        sales_person: "not required"
      })
end

def full_sandbox_invoice_request
  Collector::InvoiceRequest.new(full_invoice_request_hash)
end
