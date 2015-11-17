require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class AdjustInvoiceRequest < BaseModel
    attributes :invoice_no, :article_id,
               :description, :amount, :vat,
               :store_id, :country_code
    attributes_opt :correlation_id
  end

  class AdjustInvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = 'AdjustInvoiceRequest'

    property :amount,          as: 'Amount'
    property :article_id,      as: 'ArticleId'
    property :description,     as: 'Description'
    property :correlation_id,  as: 'CorrelationId'
    property :country_code,    as: 'CountryCode'
    property :invoice_no,      as: 'InvoiceNo'
    property :store_id,        as: 'StoreId'
    property :vat,             as: 'Vat'
  end
end
