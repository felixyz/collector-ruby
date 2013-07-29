require "collector/version"
require "collector/base_model"
require "collector/client"
require "collector/address"
require "collector/user"
require "collector/invoice_row"
require "collector/article_list_item"

require "collector/invoice_request"
require "collector/activate_invoice_request"
require "collector/get_address_request"
require "collector/invoice_response"

module Collector

  class << self
    def new(*options)
      Client.new(*options)
    end
  end

end
