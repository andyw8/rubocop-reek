# frozen_string_literal: true

require_relative "support/reek_matcher"
require_relative "support/reek_spec_fetcher"

# Runs Reek's original smell detector specs against our cops via the
# reek_of compatibility matcher. Spec files are fetched from GitHub on
# first run and cached in tmp/reek_specs/ (gitignored).
REEK_SPEC_NAMES = {
  "DuplicateMethodCall" => "duplicate_method_call"
}.freeze

REEK_SPEC_NAMES.each_value do |snake_name|
  load ReekSpecFetcher.fetch(snake_name)
end
