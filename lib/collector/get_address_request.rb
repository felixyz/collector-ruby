require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class GetAddressRequest < BaseModel

    attributes :reg_no, :store_id, :country_code
    attributes_opt :correlation_id
  end

  class GetAddressRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = "GetAddressRequest"

    property   :correlation_id,           as: "CorrelationId"
    property   :country_code,             as: "CountryCode"
    property   :reg_no,                   as: "RegNo"
    property   :store_id,                 as: "StoreId"
  end

end