# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Reek::DuplicateMethodCall, :config do
  let(:config) { RuboCop::Config.new("Reek/DuplicateMethodCall" => cop_config) }
  let(:cop_config) { {} }

  context "when a method call with a receiver is duplicated" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo
          bar.baz
          bar.baz
          ^^^^^^^ `bar.baz` is called 2 times.
        end
      RUBY
    end
  end

  context "when a method call with arguments is duplicated" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        def foo
          bar(1, 2)
          bar(1, 2)
          ^^^^^^^^^ `bar(1, 2)` is called 2 times.
        end
      RUBY
    end
  end

  context "when a method call appears more than twice" do
    it "registers an offense on the second and subsequent occurrences" do
      expect_offense(<<~RUBY)
        def foo
          bar.baz
          bar.baz
          ^^^^^^^ `bar.baz` is called 2 times.
          bar.baz
          ^^^^^^^ `bar.baz` is called 3 times.
        end
      RUBY
    end
  end

  context "when a bare method call without receiver or arguments is duplicated" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        def foo
          bar
          bar
        end
      RUBY
    end
  end

  context "when `.new` is called multiple times" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        def foo
          Foo.new
          Foo.new
        end
      RUBY
    end
  end

  context "when different calls are made" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        def foo
          bar.baz
          bar.qux
        end
      RUBY
    end
  end

  context "when the same call appears in different methods" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        def foo
          bar.baz
        end

        def qux
          bar.baz
        end
      RUBY
    end
  end

  context "with AllowCalls configured" do
    let(:cop_config) { {"AllowCalls" => ["baz"]} }

    it "does not register an offense for the allowed call" do
      expect_no_offenses(<<~RUBY)
        def foo
          bar.baz
          bar.baz
        end
      RUBY
    end
  end

  context "with MaxCalls set to 2" do
    let(:cop_config) { {"MaxCalls" => 2} }

    it "does not register an offense when a call appears twice" do
      expect_no_offenses(<<~RUBY)
        def foo
          bar.baz
          bar.baz
        end
      RUBY
    end

    it "registers an offense when a call appears three times" do
      expect_offense(<<~RUBY)
        def foo
          bar.baz
          bar.baz
          bar.baz
          ^^^^^^^ `bar.baz` is called 3 times.
        end
      RUBY
    end
  end
end
