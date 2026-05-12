# frozen_string_literal: true

require_relative "../../../support/reek_spec_fetcher"

# Runs Reek's original DuplicateMethodCall spec against our cop via the
# reek_of compatibility matcher. The spec file is fetched from GitHub on first
# run and cached in tmp/reek_specs/ (gitignored).
load ReekSpecFetcher.fetch("duplicate_method_call")
