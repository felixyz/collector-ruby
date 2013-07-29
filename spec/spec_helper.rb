require 'collector'
require 'require_all'
require 'vcr'

require_rel 'helpers'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  # c.debug_logger = $stdout
end

# logger = Logging.logger['root']
# logger.add_appenders(Logging.appenders.stdout)
# logger.level = :debug

RSpec.configure do |config|
  # config.filter_run focus: true
end

def collector_client
  user_name = 'blingo_test'
  password = 'blingo_test'
  client = nil
  VCR.use_cassette('create_client') do
    client = Collector.new(user_name, password, true)
  end
  client
end

def product1
  @product1 ||= sandbox_invoice_row(article_id: 101, unit_price: 47.5, quantity: 1)
end
def product2
  @product2 ||= sandbox_invoice_row(article_id: 102, unit_price: 61.75, quantity: 2)
end
def product3
  @product3 ||= sandbox_invoice_row(article_id: 103, unit_price: 73.15, quantity: 1)
end

def add_original_invoice
  req = sandbox_invoice_request
  req.invoice_rows = [product1, product2, product3]
  response = @client.add_invoice(req)
  response.invoice_no
end
