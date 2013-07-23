require 'spec_helper'

describe Collector::Address do
  let (:address_hash) {
    { address1: "Storgatan",
      city: "Njutånger",
      country_code: "SE",
      postal_code: "90737",
      first_name: "Svenne",
      last_name: "Banan"}
  }
  it "can be constructed from a hash" do
    address = Collector::Address.new( address_hash )
    address.address1.should eq "Storgatan"
    address.city.should eq "Njutånger"
    address.country_code.should eq "SE"
    address.postal_code.should eq "90737"
    address.first_name.should eq "Svenne"
    address.last_name.should eq "Banan"
  end

  it "converts to hash and back without losing information" do
    obj = Collector::Address.new( address_hash )
    hash = Collector::AddressRepresenter.new(obj).to_hash
    obj2 = Collector::Address.new
    Collector::AddressRepresenter.new(obj2).from_hash(hash)
    obj2.should eq obj
  end

end