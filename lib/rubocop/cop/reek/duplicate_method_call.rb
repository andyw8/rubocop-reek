# frozen_string_literal: true

module RuboCop
  module Cop
    module Reek
      # Checks for repeated identical method calls within a single method definition.
      # Repeated calls are a sign that the result should be stored in a local variable.
      #
      # @example
      #   # bad
      #   def foo
      #     bar.baz + bar.baz
      #   end
      #
      #   # good
      #   def foo
      #     result = bar.baz
      #     result + result
      #   end
      #
      class DuplicateMethodCall < Base
        MSG = "`%<call>s` is called %<count>d times."

        def on_def(node)
          check_for_duplicates(node)
        end
        alias_method :on_defs, :on_def

        private

        def check_for_duplicates(def_node)
          counts = Hash.new(0)
          calls = collect_calls(def_node.body)

          calls.each do |node|
            key = call_key(node)
            counts[key] += 1
            next if counts[key] <= max_calls

            add_offense(node, message: format(MSG, call: key, count: counts[key]))
          end
        end

        def collect_calls(node)
          return [] if node.nil?

          calls = []
          node.each_descendant(:send) do |send_node|
            calls << send_node if countable?(send_node)
          end
          calls
        end

        def countable?(node)
          return false if node.method_name == :new
          return false if allow_calls.include?(node.method_name.to_s)

          node.receiver || node.arguments.any?
        end

        def call_key(node)
          node.source
        end

        def max_calls
          cop_config.fetch("MaxCalls", 1)
        end

        def allow_calls
          cop_config.fetch("AllowCalls", [])
        end
      end
    end
  end
end
