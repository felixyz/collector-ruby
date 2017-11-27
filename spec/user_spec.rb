# encoding: utf-8
require 'spec_helper'
require 'active_support'
require 'active_support/core_ext'

describe Collector::User do
  let :raw_get_address_reponse_hash do
    { get_address_response: { addresses:
                                { base_address:
                                  { address1: 'Gatuadressakt211',
                                    address2: nil,
                                    co_address: nil,
                                    city: 'Umeå',
                                    country_code: 'SE',
                                    postal_code: '90737' },
                              :"@xmlns:i" => 'http://www.w3.org/2001/XMLSchema-instance' },
                              correlation_id: nil,
                              firstname: 'Förnamnakt211',
                              lastname: 'Efternamnakt211',
                              reg_no: '1602079954',
                              :@xmlns => 'http://schemas.ecommerce.collector.se/v30/InvoiceService' } }
  end
  it 'can be constructed from a hash' do
    hash = raw_get_address_reponse_hash[:get_address_response]
           .with_indifferent_access
    user = Collector::User.new
    Collector::UserRepresenter.new(user).from_hash(hash)
    user.first_name.should eq 'Förnamnakt211'
    user.last_name.should eq 'Efternamnakt211'
    user.reg_no.should eq '1602079954'
    user.addresses.should be_kind_of Array
    address = user.addresses.first
    address.should be_kind_of Collector::Address
    address.address1.should eq 'Gatuadressakt211'
    address.address2.should be_nil
    address.co_address.should be_nil
    address.city.should eq 'Umeå'
    address.country_code.should eq 'SE'
    address.postal_code.should eq '90737'
  end
end
