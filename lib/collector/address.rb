require 'representable/hash'

module Collector
  class Address < BaseModel
    attributes :address1, :address2, :city,
      :country_code, :postal_code, :first_name, :last_name
    # :co_address, :cell_phone_number, :company_name, :email, :phone_number
  end

  class AddressRepresenter < Representable::Decorator
    include Representable::Hash

    property :address1,     as: :Address1
    property :address2,     as: :Address2
    property :city,         as: :City
    property :country_code, as: :CountryCode
    property :postal_code,  as: :PostalCode
    property :first_name,   as: :Firstname
    property :last_name,    as: :Lastname
  end
end