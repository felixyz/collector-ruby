require 'spec_helper'
require 'vcr'
require 'webmock/rspec'
require 'nori'  # Available through Savon

describe "Collector::Client#get_address" do
  before :all do
    @client = collector_client
  end
  it "performs a GetAddress request"
  # do
  #   VCR.use_cassette('get_address') do
  #     response = @client.get_address(reg_no: "1602079954", store_id: "355")
  #     response.should be_kind_of Collector::User
  #     response.first_name.should eq "FÖRNAMNAKT211"
  #     response.last_name.should eq "EFTERNAMNAKT211"
  #     response.reg_no.should eq "1602079954"
  #     response.addresses.should be_kind_of Array
  #   end
  # end
end