require 'representable/hash'

module Collector
  class User < BaseModel
    swallow_unsupported_attributes

    attributes :first_name, :last_name, :reg_no, :addresses
  end

  class UserRepresenter < Representable::Decorator
    include Representable::Hash

    property :first_name,        as: :firstname
    property :last_name,         as: :lastname
    property :reg_no
    property :addresses,
             reader: lambda {|doc, _args|
               addresses = doc[:addresses]
               doc[:addresses] = [addresses] unless addresses.is_a? Array
               self.addresses = addresses.map{|key, adr|
                 key == 'base_address' ? Address.new(adr) : nil
               }.compact
             }
  end
end
