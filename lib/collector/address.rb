require 'representable/hash'

module Collector
  class Address < BaseModel
    attributes :address1, :city,
      :country_code, :postal_code
    attributes_opt :address2, :co_address, :cell_phone_number,
      :company_name, :email, :first_name,
      :last_name, :phone_number
  end

  class AddressRepresenter < Representable::Decorator
    include Representable::Hash

    property :address1,           as: :Address1
    property :address2,           as: :Address2
    property :co_address,         as: :COAddress
    property :city,               as: :City
    property :country_code,       as: :CountryCode
    property :postal_code,        as: :PostalCode
    property :cell_phone_number,  as: :CellPhoneNumber
    property :company_name,       as: :CompanyName
    property :email,              as: :Email
    property :first_name,         as: :Firstname
    property :last_name,          as: :Lastname
    property :phone_number,       as: :PhoneNumber
  end
end