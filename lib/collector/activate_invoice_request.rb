require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class ActivateInvoiceRequest < BaseModel

    attributes :invoice_no, :country_code, :store_id
    attributes_opt :correlation_id
  end

  class ActivateInvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = "ActivateInvoiceRequest"

    property   :correlation_id,           as: "CorrelationId"
    property   :country_code,             as: "CountryCode"
    property   :invoice_no,               as: "InvoiceNo"
    property   :store_id,                 as: "StoreId"
  end

end