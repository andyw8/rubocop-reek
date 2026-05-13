# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

`rubocop-reek` is a RuboCop plugin that ports [Reek](https://github.com/troessner/reek)'s code smell detectors into RuboCop cops. The motivation (see [troessner/reek#1512](https://github.com/troessner/reek/issues/1512)) is to leverage RuboCop's mature infrastructure — configuration system, todo generation, node matchers, file processing — rather than maintaining duplicate tooling in Reek.

Each Reek smell detector becomes a RuboCop cop under the `Reek/` department.

## Commands

```bash
bundle exec rake          # run tests + standard linting (default CI task)
bundle exec rake spec     # RSpec only
bundle exec rake standard # linting only
```

Run a single RSpec file:
```bash
bundle exec rspec spec/rubocop/cop/reek/some_cop_spec.rb
```

Generate a new cop scaffold:
```bash
bundle exec rake new_cop[Reek/CopName]
```
This writes the cop source, spec, registers it in `lib/rubocop/cop/reek_cops.rb`, and adds an entry to `config/default.yml`.

## Architecture

### Plugin registration

`rubocop-reek.gemspec` sets `metadata['default_lint_roller_plugin']` to `RuboCop::Reek::Plugin`, which makes RuboCop auto-load this gem as a plugin when it appears in the bundle.

`lib/rubocop/reek/plugin.rb` (`RuboCop::Reek::Plugin < LintRoller::Plugin`) points RuboCop at `config/default.yml` for cop configuration.

### Load chain

```
rubocop-reek.rb
  └─ rubocop/reek.rb          # defines RuboCop::Reek module
  └─ rubocop/reek/version.rb
  └─ rubocop/reek/plugin.rb   # LintRoller plugin
  └─ rubocop/cop/reek_cops.rb # requires all individual cop files (currently empty)
```

### Adding a cop

1. Run `bundle exec rake new_cop[Reek/SmellName]` — this scaffolds everything.
2. Implement the cop in `lib/rubocop/cop/reek/smell_name.rb` using RuboCop's AST node pattern matching.
3. Write an RSpec test in `spec/rubocop/cop/reek/smell_name_spec.rb` using `RuboCop::RSpec::ExpectOffense` helpers (already available via `rubocop/rspec/support` in `spec/spec_helper.rb`).

After implementing a cop:
- Update the cops table in `README.md`: change the status from `pending` to `done` and add a link to the cop source file (following the pattern of existing done rows).
- Add the cop to `REEK_SPEC_NAMES` in `spec/reek_specs_spec.rb`, to `COP_MAP` in `spec/support/reek_matcher.rb`, and add any Reek config key mappings to `CONFIG_KEY_MAP`. Also add any `described_class::CONSTANT` substitutions to the `transform` method in `spec/support/reek_spec_fetcher.rb`.

**Scaffold gotchas:**
- The generated spec contains a `let(:config)` stub and placeholder tests — replace the entire spec body rather than editing around the boilerplate.
- The scaffold injects the `require_relative` in `reek_cops.rb` with single quotes, which fails Standard linting. Fix it to double quotes immediately.
- Use `let(:cop_config) { {"ParameterName" => value} }` in specs to configure cop parameters; do not use `let(:config)`.
- Reek is not in the bundle. For reference on Reek's defaults and behaviour, check the Reek source on GitHub or the cached specs in `tmp/reek_specs/`.

### Test setup

RSpec (`spec/`) is the test framework for cop specs. `spec/spec_helper.rb` loads `rubocop/rspec/support`, which provides the `expect_offense`/`expect_no_offenses` helpers used in cop specs.

Each cop has a hand-written spec in `spec/rubocop/cop/reek/<name>_spec.rb` using RuboCop's `expect_offense`/`expect_no_offenses` helpers.

In addition, `spec/reek_specs_spec.rb` runs Reek's original smell detector specs against all implemented cops via the `reek_of` compatibility matcher (`spec/support/reek_matcher.rb`). Spec files are fetched from GitHub on first run and cached in `tmp/reek_specs/` (gitignored). Delete that directory to force a refresh. The fetcher transforms the downloaded specs by stripping Reek-specific requires, rewriting the describe class to point at our cop, and replacing Reek detector constants with their RuboCop equivalents.

### Configuration

`config/default.yml` is the authoritative cop configuration file shipped with the gem. Each cop entry should include `Enabled: true` (or `false` for opt-in smells) and any tunable parameters.

## Reference

[RuboCop Development Guide](https://docs.rubocop.org/rubocop/latest/development.html) — covers cop implementation patterns, AST node matching, autocorrect, performance (`RESTRICT_ON_SEND`), documentation conventions, and testing.
