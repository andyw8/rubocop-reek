# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Reek::NilCheck, :config do
  context "when using .nil?" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo(bar)
          bar.nil?
          ^^^^^^^^ performs a nil-check.
        end
      RUBY
    end
  end

  context "when using == nil" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo(bar)
          bar == nil
          ^^^^^^^^^^ performs a nil-check.
        end
      RUBY
    end
  end

  context "when using nil ==" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo(bar)
          nil == bar
          ^^^^^^^^^^ performs a nil-check.
        end
      RUBY
    end
  end

  context "when using === nil" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo(bar)
          bar === nil
          ^^^^^^^^^^^ performs a nil-check.
        end
      RUBY
    end
  end

  context "when using a case/when with nil" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo(bar)
          case bar
          when nil then "nothing"
          ^^^^^^^^^^^^^^^^^^^^^^^ performs a nil-check.
          end
        end
      RUBY
    end
  end

  context "when using safe navigation" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        def foo(bar)
          bar&.baz
        end
      RUBY
    end
  end

  context "when no nil check is performed" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        def foo(bar)
          bar == "something"
        end
      RUBY
    end
  end
end
