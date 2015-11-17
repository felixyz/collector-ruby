require 'spec_helper'
require 'vcr'

describe 'Collector::Client#get_address' do
  before :all do
    @client = collector_client
  end
  it 'performs a GetAddress request' do
    VCR.use_cassette('get_address') do
      user = @client.get_address(reg_no: '1602079954', store_id: '355')
      user.should be_kind_of Collector::User
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
  it 'raises an error when handed an non-existing registration number' do
    VCR.use_cassette('get_nonexisting_address') do
      expect { @client.get_address(reg_no: '1602079955', store_id: '355') }.to raise_error{|err|
        err.should be_a(Collector::CollectorError)
        err.faultcode.should eq 'INVALID_REGISTRATION_NUMBER'
      }
    end
  end
end
