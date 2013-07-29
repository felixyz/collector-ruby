require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class CancelInvoiceRequest < BaseModel

    attributes :invoice_no, :store_id, :country_code
    attributes_opt :correlation_id
  end

  class CancelInvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = "CancelInvoiceRequest"

    property   :correlation_id,           as: "CorrelationId"
    property   :country_code,             as: "CountryCode"
    property   :invoice_no,               as: "InvoiceNo"
    property   :store_id,                 as: "StoreId"
  end

end