require 'representable/hash'

module Collector
  class InvoiceResponse < BaseModel
    swallow_unsupported_attributes # Accept unknown attributes returned from service

    attributes_opt :available_reservation_amount, :correlation_id, :due_date,
                   :invoice_no, :invoice_status, :invoice_url,
                   :lowest_amount_to_pay, :payment_reference, :total_amount,
                   :new_invoice_no
  end

  class InvoiceResponseRepresenter < Representable::Decorator
    include Representable::Hash

    property :available_reservation_amount
    property :correlation_id
    property :due_date
    property :invoice_no
    property :invoice_status
    property :invoice_url
    property :lowest_amount_to_pay
    property :new_invoice_no
    property :payment_reference
    property :total_amount
  end
end
