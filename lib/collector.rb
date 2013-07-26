require "collector/version"
require "collector/base_model"
require "collector/client"
require "collector/user"
require "collector/address"
require "collector/invoice_row"
require "collector/invoice_request"
require "collector/get_address_request"
require "collector/add_invoice_response"

module Collector

  class << self
    def new(*options)
      Client.new(*options)
    end
  end

end
