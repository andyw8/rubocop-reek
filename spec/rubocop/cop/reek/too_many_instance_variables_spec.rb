# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Reek::TooManyInstanceVariables, :config do
  let(:cop_config) { {"MaxInstanceVariables" => 4} }

  context "when a class has more than the maximum instance variables" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        class Foo
              ^^^ has too many instance variables [5/4].
          def initialize
            @a = 1
            @b = 2
            @c = 3
            @d = 4
            @e = 5
          end
        end
      RUBY
    end
  end

  context "when a class has exactly the maximum instance variables" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize
            @a = 1
            @b = 2
            @c = 3
            @d = 4
          end
        end
      RUBY
    end
  end

  context "when a class has fewer than the maximum instance variables" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize
            @a = 1
            @b = 2
          end
        end
      RUBY
    end
  end

  context "when the same instance variable is assigned multiple times" do
    it "counts it only once" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize
            @a = 1
            @a = 2
            @b = 3
            @c = 4
          end
        end
      RUBY
    end
  end

  context "when instance variables are read and written" do
    it "counts unique names only" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def work
            @a = 1
            @b = @a + 1
            @c = @b + 1
            @d = @c + 1
          end
        end
      RUBY
    end
  end
end
