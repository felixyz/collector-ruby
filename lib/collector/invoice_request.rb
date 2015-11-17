require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class InvoiceRequest < BaseModel
    attributes :activation_option, :country_code, :currency,
               :delivery_address, :invoice_address, :invoice_delivery_method,
               :invoice_rows, :invoice_type, :order_date,
               :reg_no, :store_id

    attributes_opt :correlation_id, :cost_center, :credit_time, :customer_no,
                   :gender, :order_no, :product_code,
                   :purchase_type, :reference, :sales_person
  end

  class InvoiceRowListRepresenter < Representable::Decorator
    include Representable::Hash::Collection
    self.representation_wrap = 'InvoiceRow'
    items extend: InvoiceRowRepresenter, class: InvoiceRow
  end

  class InvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = 'AddInvoiceRequest'

    property :activation_option,        as: 'ActivationOption'
    property :correlation_id,           as: 'CorrelationId'
    property :cost_center,              as: 'CostCenter'
    property :country_code,             as: 'CountryCode'
    property :credit_time,              as: 'CreditTime'
    property :currency,                 as: 'Currency'
    property :customer_no,              as: 'CustomerNo'
    property :delivery_address,         as: 'DeliveryAddress',
                                        decorator: AddressRepresenter,
                                        class: Address
    property :gender,                   as: 'Gender'
    property :invoice_address,          as: 'InvoiceAddress',
                                        decorator: AddressRepresenter,
                                        class: Address
    property :invoice_delivery_method,  as: 'InvoiceDeliveryMethod'
    property :invoice_rows,
             writer: lambda {|doc, _args|
               doc['InvoiceRows'] = InvoiceRowListRepresenter.new(invoice_rows).to_hash
             },
             reader: lambda {|doc, _args|
               rows = doc['InvoiceRows']['InvoiceRow']
               self.invoice_rows = rows.map { |row| InvoiceRowRepresenter.new(InvoiceRow.new).from_hash(row) }
             }
    property :invoice_type,             as: 'InvoiceType'
    property :order_date,               as: 'OrderDate', type: DateTime
    property :order_no,                 as: 'OrderNo'
    property :product_code,             as: 'ProductCode'
    property :purchase_type,            as: 'PurchaseType'
    property :reference,                as: 'Reference'
    property :reg_no,                   as: 'RegNo'
    property :sales_person,             as: 'SalesPerson'
    property :store_id,                 as: 'StoreId'
  end
end
