require 'representable/hash'
require 'representable/hash/collection'

module Collector
  class ActivateInvoiceRequest < BaseModel

    attributes :invoice_no, :country_code, :store_id
    attributes_opt :correlation_id, :article_list
  end

  class ActivateInvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = "ActivateInvoiceRequest"

    property   :correlation_id,           as: "CorrelationId"
    property   :country_code,             as: "CountryCode"
    property   :invoice_no,               as: "InvoiceNo"
    property   :store_id,                 as: "StoreId"
  end

  class ArticleListRepresenter < Representable::Decorator
    include Representable::Hash::Collection
    self.representation_wrap = "Article"
    items extend: ArticleListItemRepresenter, class: ArticleListItem
  end

  # TODO: Figure out how to make subclassing work
  class PartActivateInvoiceRequestRepresenter < Representable::Decorator
    include Representable::Hash

    self.representation_wrap = "PartActivateInvoiceRequest"

    property   :article_list,
                  writer: lambda {|doc, args|
                    doc["ArticleList"] = ArticleListRepresenter.new(article_list).to_hash
                  }

    property   :correlation_id,           as: "CorrelationId"
    property   :country_code,             as: "CountryCode"
    property   :invoice_no,               as: "InvoiceNo"
    property   :store_id,                 as: "StoreId"
  end

end