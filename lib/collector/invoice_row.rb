require 'representable/hash'

module Collector
  class InvoiceRow < BaseModel
    attributes :article_id, :description, :quantity, :unit_price, :vat
  end

  class InvoiceRowRepresenter < Representable::Decorator
    include Representable::Hash

    property :article_id,   as: 'ArticleId'
    property :description,  as: 'Description'
    property :quantity,     as: 'Quantity'
    property :unit_price,   as: 'UnitPrice'
    property :vat,          as: 'VAT'
  end
end
