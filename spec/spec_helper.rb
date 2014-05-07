if RUBY_ENGINE == 'ruby'
  require 'simplecov'

  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start
end

require 'vcr'
require 'timecop'
require 'scalr_api'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

def vcr_in_time(cassette, opts = { record: :once },  &block)
  return unless block_given?
  VCR.use_cassette(cassette, opts) do |cas|
    Timecop.freeze(cas.originally_recorded_at || Time.now) do
      yield
    end
  end
end
