module Collector
  class ArticleListItem < BaseModel
    attributes :article_id, :quantity, :description

    def initialize(hash_or_invoice_row = {})
      if hash_or_invoice_row.kind_of? Hash
        super(hash_or_invoice_row)
      elsif hash_or_invoice_row.kind_of? InvoiceRow
        hash = attributes.inject({}) do |memo, attr|
          memo[attr] = hash_or_invoice_row.send(attr)
          memo
        end
        super(hash)
      else
        raise ArgumentError.new("An ArticleListItem must be initialized with a hash or an InvoiceRow instance.")
      end
    end
  end

  class ArticleListItemRepresenter < Representable::Decorator
    include Representable::Hash

    property :article_id,      as: "ArticleId"
    property :quantity,        as: "Quantity"
    property :description,     as: "Description"
  end

end