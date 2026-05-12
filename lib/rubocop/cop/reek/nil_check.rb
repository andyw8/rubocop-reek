# frozen_string_literal: true

module RuboCop
  module Cop
    module Reek
      # Checks for nil checks, which are a special kind of type check and a
      # form of simulated polymorphism. Consider using the null object pattern
      # or safe navigation instead.
      #
      # @example
      #   # bad
      #   def foo(bar)
      #     bar.nil?
      #   end
      #
      #   # bad
      #   def foo(bar)
      #     bar == nil
      #   end
      #
      #   # bad
      #   def foo(bar)
      #     case bar
      #     when nil then "nothing"
      #     end
      #   end
      #
      #   # good
      #   def foo(bar)
      #     bar&.baz
      #   end
      #
      class NilCheck < Base
        MSG = "performs a nil-check."

        RESTRICT_ON_SEND = %i[nil? == ===].freeze

        def on_send(node)
          add_offense(node) if nil_query?(node) || nil_comparison?(node)
        end

        def on_when(node)
          add_offense(node) if node.conditions.any?(&:nil_type?)
        end

        private

        def nil_query?(node)
          node.method_name == :nil? && node.arguments.none?
        end

        def nil_comparison?(node)
          %i[== ===].include?(node.method_name) &&
            (node.first_argument&.nil_type? || node.receiver&.nil_type?)
        end
      end
    end
  end
end
