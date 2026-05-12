# frozen_string_literal: true

# Compatibility layer that lets Reek's original spec examples run against our
# RuboCop cop implementations with minimal modification.
#
# Usage mirrors Reek's matcher API:
#
#   expect(src).to reek_of(:DuplicateMethodCall, name: "foo.bar", count: 2)
#   expect(src).not_to reek_of(:DuplicateMethodCall)
#   expect(src).to reek_of(...).with_config("max_calls" => 3)
#
# Unsupported Reek attributes (context:, source:) are silently ignored.

module ReekMatcher
  CONFIG_KEY_MAP = {
    "max_calls" => "MaxCalls",
    "allow_calls" => "AllowCalls"
  }.freeze

  COP_MAP = {
    "DuplicateMethodCall" => RuboCop::Cop::Reek::DuplicateMethodCall,
    "NilCheck" => RuboCop::Cop::Reek::NilCheck
  }.freeze

  RUBY_VERSION_FLOAT = RUBY_VERSION.to_f

  class Matcher
    include RSpec::Matchers::Composable

    def initialize(smell_type, attributes, extra_config = {})
      @smell_type = smell_type.to_s
      @attributes = attributes
      @extra_config = extra_config
    end

    def with_config(config_hash)
      mapped = config_hash.transform_keys { |k| CONFIG_KEY_MAP.fetch(k.to_s, k.to_s) }
      mapped = mapped.transform_values do |v|
        if v.is_a?(Array)
          v.map { |item| item.is_a?(Regexp) ? item.source : item.to_s }
        else
          v
        end
      end
      self.class.new(@smell_type, @attributes, mapped)
    end

    def matches?(source)
      @offenses = run_cop(source)
      matching_offenses.any?
    end

    def does_not_match?(source)
      @offenses = run_cop(source)
      matching_offenses.none?
    end

    def failure_message
      "expected offenses matching #{@attributes.inspect}, but got:\n#{offense_summary}"
    end

    def failure_message_when_negated
      "expected no offenses matching #{@attributes.inspect}, but got:\n#{offense_summary}"
    end

    def description
      "reek of #{@smell_type}"
    end

    private

    def run_cop(source)
      cop_class = COP_MAP.fetch(@smell_type) { raise ArgumentError, "Unknown smell type: #{@smell_type}" }
      config = RuboCop::Config.new("Reek/#{@smell_type}" => {"Enabled" => true}.merge(@extra_config))
      cop = cop_class.new(config)
      commissioner = RuboCop::Cop::Commissioner.new([cop])
      processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION_FLOAT)
      commissioner.investigate(processed_source).offenses
    end

    def matching_offenses
      @offenses.select { |offense| matches_attributes?(offense) }
    end

    def matches_attributes?(offense)
      matches_name?(offense) && matches_count?(offense) && matches_lines?(offense)
    end

    def matches_name?(offense)
      return true unless @attributes.key?(:name)
      offense.message.include?(@attributes[:name])
    end

    def matches_count?(offense)
      return true unless @attributes.key?(:count)
      offense.message.include?("#{@attributes[:count]} times")
    end

    def matches_lines?(offense)
      return true unless @attributes.key?(:lines)
      @attributes[:lines].include?(offense.line)
    end

    def offense_summary
      return "  (none)" if @offenses.empty?
      @offenses.map { |o| "  line #{o.line}: #{o.message}" }.join("\n")
    end
  end
end

module ReekMatcher
  def reek_of(smell_type, attributes = {})
    Matcher.new(smell_type, attributes)
  end
end
