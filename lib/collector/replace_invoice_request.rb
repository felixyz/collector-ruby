require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class ReplaceInvoiceRequest < BaseModel
    attributes :invoice_no, :invoice_rows,
               :store_id, :country_code
    attributes_opt :correlation_id
  end

  class ReplaceInvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = 'ReplaceInvoiceRequest'

    property :correlation_id,  as: 'CorrelationId'
    property :country_code,    as: 'CountryCode'
    property :invoice_no,      as: 'InvoiceNo'
    property :invoice_rows,
             writer: lambda {|doc, _args|
               doc['InvoiceRows'] = InvoiceRowListRepresenter.new(invoice_rows).to_hash
             },
             reader: lambda {|doc, _args|
               rows = doc['InvoiceRows']['InvoiceRow']
               self.invoice_rows = rows.map { |row| InvoiceRowRepresenter.new(InvoiceRow.new).from_hash(row) }
             }
    property :store_id, as: 'StoreId'
  end
end
