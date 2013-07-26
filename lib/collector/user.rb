require 'representable/hash'

module Collector
  class User < BaseModel
    swallow_unsupported_attributes

    attributes :first_name, :last_name, :reg_no, :addresses
  end

  class UserRepresenter < Representable::Decorator
    include Representable::Hash

    property :first_name,         as: :Firstname
    property :last_name,          as: :Lastname
    property :reg_no,             as: :RegNo
    # TODO: Implement BaseAddress
    # collection :addresses,        as: :Addresses,
    #                               decorator: BaseAddressRepresenter,
    #                               class: BaseAddress
  end
end