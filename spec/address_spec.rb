require 'spec_helper'

describe Collector::Address do
  let (:address_hash) do
    { address1: 'Storgatan',
      city: 'Njutånger',
      country_code: 'SE',
      postal_code: '90737',
      first_name: 'Svenne',
      last_name: 'Banan' }
  end
  it 'can be constructed from a hash' do
    address = Collector::Address.new(address_hash)
    address.address1.should eq 'Storgatan'
    address.city.should eq 'Njutånger'
    address.country_code.should eq 'SE'
    address.postal_code.should eq '90737'
    address.first_name.should eq 'Svenne'
    address.last_name.should eq 'Banan'
  end

  it 'converts to hash and back without losing information' do
    obj = Collector::Address.new(address_hash)
    hash = Collector::AddressRepresenter.new(obj).to_hash
    obj2 = Collector::Address.new
    Collector::AddressRepresenter.new(obj2).from_hash(hash)
    obj2.should eq obj
  end

  it 'reports that all required attributes are present if they are' do
    full_address = Collector::Address.new(address_hash)
    full_address.should have_required_attributes
    full_address.missing_attributes.should be_empty
  end

  it 'reports missing attributes' do
    incomplete = address_hash.dup
    incomplete.delete(:address1)
    incomplete.delete(:postal_code)
    incomplete_address = Collector::Address.new(incomplete)
    incomplete_address.should_not have_required_attributes
    incomplete_address.missing_attributes.should eq [:address1, :postal_code]
  end
end
