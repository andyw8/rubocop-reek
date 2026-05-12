# frozen_string_literal: true

module RuboCop
  module Cop
    module Reek
      # Checks that a class has no more than a configurable number of instance
      # variables. Too many instance variables is a common sign that a class
      # has too many responsibilities and should be split up.
      #
      # @example
      #   # bad (with default MaxInstanceVariables: 4)
      #   class Foo
      #     def initialize
      #       @a = 1
      #       @b = 2
      #       @c = 3
      #       @d = 4
      #       @e = 5
      #     end
      #   end
      #
      #   # good
      #   class Foo
      #     def initialize
      #       @a = 1
      #       @b = 2
      #       @c = 3
      #       @d = 4
      #     end
      #   end
      #
      class TooManyInstanceVariables < Base
        MSG = "has too many instance variables [%<count>d/%<max>d]."

        def on_class(node)
          ivars = collect_ivars(node)
          max = cop_config["MaxInstanceVariables"]
          return if ivars.size <= max

          add_offense(node.loc.name, message: format(MSG, count: ivars.size, max: max))
        end

        private

        def collect_ivars(node)
          names = []
          node.each_child_node do |child|
            collect_ivars_from(child, names)
          end
          names.uniq
        end

        def collect_ivars_from(node, names)
          return if node.class_type? || node.module_type?
          # or_asgn covers memoization (@foo ||= ...) — Reek excludes these
          return if node.or_asgn_type?

          names << node.children.first if node.ivar_type? || node.ivasgn_type?
          node.each_child_node { |child| collect_ivars_from(child, names) }
        end
      end
    end
  end
end
