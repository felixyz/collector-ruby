require 'collector'
require 'require_all'
require 'vcr'

require_rel 'helpers'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

# logger = Logging.logger['root']
# logger.add_appenders(Logging.appenders.stdout)
# logger.level = :debug

RSpec.configure do |config|
  # config.filter_run focus: true
end