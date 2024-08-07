require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  add_filter 'spec/'
end
SimpleCov.minimum_coverage 95
require './autoload'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.before { allow($stdout).to receive(:puts) }
end
