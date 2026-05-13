# frozen_string_literal: true

require "fileutils"
require_relative "reek_matcher"

module ReekSpecFetcher
  REEK_REPO = "troessner/reek"
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
      warn "Fetching Reek spec via gh: #{REEK_REPO}/#{relative_path}"
      raw = `gh api repos/#{REEK_REPO}/contents/#{relative_path} --jq '.content' | base64 --decode`
      raise "gh CLI failed fetching #{relative_path}" unless $?.success?
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

    # Skip tests that verify Reek's inline config feature (# :reek:CopName { ... }),
    # which has no equivalent in RuboCop's cop infrastructure.
    lines = result.lines
    lines.each_with_index do |line, i|
      next unless line.include?("# :reek:")
      j = i - 1
      j -= 1 while j >= 0 && !lines[j].match?(/^\s*it\s+/)
      next unless j >= 0
      indent = lines[j][/^\s*/] + "  "
      lines.insert(j + 1, "#{indent}skip \"Reek inline config (# :reek:) has no RuboCop equivalent\"\n")
    end
    lines.join
  end
end
