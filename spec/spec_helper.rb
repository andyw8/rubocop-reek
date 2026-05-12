# frozen_string_literal: true

require "rubocop-reek"
require "rubocop/rspec/support"
require_relative "support/reek_matcher"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
  config.fail_if_no_examples = true

  config.order = :random
  Kernel.srand config.seed
end
