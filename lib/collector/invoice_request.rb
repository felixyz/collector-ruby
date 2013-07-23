require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class InvoiceRequest < BaseModel

    attributes :activation_option, :country_code, :currency,
        :delivery_address, :invoice_address, :invoice_delivery_method,
        :invoice_rows, :invoice_type, :order_date,
        :reg_no, :store_id

    #:CorrelationId #:CostCenter #:CustomerNo # :OrderNo # :ProductCode # :PurchaseType # :Reference # :SalesPerson # :CreditTime # :Gender

  end

  class InvoiceRowListRepresenter < Representable::Decorator
    include Representable::Hash::Collection
    self.representation_wrap = "InvoiceRow"
    items extend: InvoiceRowRepresenter, class: InvoiceRow
  end

  class InvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = "AddInvoiceRequest"

    property   :activation_option,        as: "ActivationOption"
    property   :country_code,             as: "CountryCode"
    property   :currency,                 as: "Currency"
    property   :delivery_address,         as: "DeliveryAddress",
                                          decorator: AddressRepresenter,
                                          class: Address
    property   :invoice_address,          as: "InvoiceAddress",
                                          decorator: AddressRepresenter,
                                          class: Address
    property   :invoice_delivery_method,  as: "InvoiceDeliveryMethod"
    property   :invoice_rows,
                  writer: lambda {|doc, args|
                    doc["InvoiceRows"] = InvoiceRowListRepresenter.new(invoice_rows).to_hash
                  },
                  reader: lambda {|doc, args|
                    rows = doc["InvoiceRows"]["InvoiceRow"]
                    self.invoice_rows = rows.map{|row| InvoiceRowRepresenter.new(InvoiceRow.new).from_hash(row) }
                  }
    property   :invoice_type,             as: "InvoiceType"
    property   :order_date,               as: "OrderDate", :type => DateTime
    property   :reg_no,                   as: "RegNo"
    property   :store_id,                 as: "StoreId"
  end

end