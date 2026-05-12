# frozen_string_literal: true

require "open-uri"
require "fileutils"
require_relative "reek_matcher"

module ReekSpecFetcher
  REEK_RAW_BASE = "https://raw.githubusercontent.com/troessner/reek/master"
  CACHE_DIR = File.expand_path("../../../tmp/reek_specs", __FILE__)

  # Derived from ReekMatcher::COP_MAP — single source of truth for the cop mapping.
  COP_CLASS_MAP = ReekMatcher::COP_MAP.transform_keys { |name|
    "Reek::SmellDetectors::#{name}"
  }.transform_values(&:name).freeze

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
    result = source.gsub(/^require(?:_relative|_lib).*\n/, "")

    COP_CLASS_MAP.each do |reek_class, cop_class|
      result = result.gsub(reek_class, cop_class)
    end

    result = result.gsub("described_class::MAX_ALLOWED_CALLS_KEY", '"MaxCalls"')
    result = result.gsub("described_class::ALLOW_CALLS_KEY", '"AllowCalls"')
    result = result.gsub("described_class::MAX_ALLOWED_IVARS_KEY", '"max_instance_variables"')

    # Reek inline config comments (# :reek:CopName { ... }) have no RuboCop equivalent.
    lines = result.lines
    lines.each_with_index do |line, i|
      next unless line.include?("# :reek:")
      j = i - 1
      j -= 1 while j >= 0 && !lines[j].match?(/^\s*it\s+/)
      lines[j] = lines[j].sub(/\bit\b/, "xit") if j >= 0
    end
    lines.join
  end
end
