# frozen_string_literal: true

require "open-uri"
require "fileutils"

module ReekSpecFetcher
  REEK_RAW_BASE = "https://raw.githubusercontent.com/troessner/reek/master"
  CACHE_DIR = File.expand_path("../../../tmp/reek_specs", __FILE__)

  # Maps Reek smell detector class names to our RuboCop cop classes.
  COP_CLASS_MAP = {
    "Reek::SmellDetectors::DuplicateMethodCall" => "RuboCop::Cop::Reek::DuplicateMethodCall"
  }.freeze

  def self.fetch(smell_name)
    relative_path = "spec/reek/smell_detectors/#{smell_name}_spec.rb"
    dest = File.join(CACHE_DIR, relative_path)

    unless File.exist?(dest)
      FileUtils.mkdir_p(File.dirname(dest))
      url = "#{REEK_RAW_BASE}/#{relative_path}"
      warn "Fetching Reek spec from #{url}"
      raw = URI.parse(url).open(&:read)
      File.write(dest, transform(raw))
    end

    dest
  end

  def self.transform(source)
    # Remove Reek-specific requires (handled by our spec_helper)
    result = source.gsub(/^require_relative.*\n/, "")
    result = result.gsub(/^require_lib.*\n/, "")

    # Rewrite describe block to point at our cop class
    COP_CLASS_MAP.each do |reek_class, cop_class|
      result = result.gsub(reek_class, cop_class)
    end

    # Replace Reek detector constants with our cop config key strings
    result = result.gsub("described_class::MAX_ALLOWED_CALLS_KEY", '"MaxCalls"')
    result.gsub("described_class::ALLOW_CALLS_KEY", '"AllowCalls"')
  end
end
