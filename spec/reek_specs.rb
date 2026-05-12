# frozen_string_literal: true

require_relative "support/reek_spec_fetcher"

# Runs Reek's original smell detector specs against our cops via the
# reek_of compatibility matcher. Spec files are fetched from GitHub on
# first run and cached in tmp/reek_specs/ (gitignored).
ReekMatcher::COP_MAP.each_key do |smell_name|
  snake_name = smell_name.gsub(/([A-Z])/, '_\1').downcase.delete_prefix("_")
  load ReekSpecFetcher.fetch(snake_name)
end
