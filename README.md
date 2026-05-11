# rubocop-reek

A RuboCop plugin that ports [Reek](https://github.com/troessner/reek)'s code smell detectors as RuboCop cops.

Reek has a number of long-standing limitations around configuration, file processing, and tooling integration. This gem addresses them by leveraging RuboCop's mature infrastructure — battle-tested configuration, todo generation, node pattern matching, and IDE/editor support — rather than maintaining duplicate tooling. See [troessner/reek#1512](https://github.com/troessner/reek/issues/1512) for the original discussion.

## Installation

Add to your application's Gemfile:

```ruby
gem "rubocop-reek", require: false
```

Or install directly:

```bash
gem install rubocop-reek
```

Because this gem registers itself as a RuboCop plugin via `lint_roller`, RuboCop will auto-load it when it is present in your bundle. No explicit `require` or `plugins:` entry in `.rubocop.yml` is needed.

## Usage

Once installed, the `Reek/` department of cops is available. Cops can be configured in `.rubocop.yml` like any other RuboCop cop:

```yaml
Reek/SomeCopName:
  Enabled: true
```

## Cops

| Reek detector | Cop | Status | Possible RuboCop overlap |
|---|---|---|---|
| `Attribute` | `Reek/Attribute` | pending | `Style/AccessorGrouping` |
| `BooleanParameter` | `Reek/BooleanParameter` | pending | |
| `ClassVariable` | `Reek/ClassVariable` | pending | |
| `ControlParameter` | `Reek/ControlParameter` | pending | |
| `DataClump` | `Reek/DataClump` | pending | |
| `DuplicateMethodCall` | [`Reek/DuplicateMethodCall`](lib/rubocop/cop/reek/duplicate_method_call.rb) | done | |
| `FeatureEnvy` | `Reek/FeatureEnvy` | pending | |
| `InstanceVariableAssumption` | `Reek/InstanceVariableAssumption` | pending | |
| `IrresponsibleModule` | `Reek/IrresponsibleModule` | pending | `Style/Documentation` |
| `LongParameterList` | `Reek/LongParameterList` | pending | `Metrics/ParameterLists` |
| `LongYieldList` | `Reek/LongYieldList` | pending | |
| `ManualDispatch` | `Reek/ManualDispatch` | pending | |
| `MissingSafeMethod` | `Reek/MissingSafeMethod` | pending | |
| `ModuleInitialize` | `Reek/ModuleInitialize` | pending | |
| `NestedIterators` | `Reek/NestedIterators` | pending | `Metrics/BlockNesting` |
| `NilCheck` | `Reek/NilCheck` | pending | `Style/NilComparison` |
| `RepeatedConditional` | `Reek/RepeatedConditional` | pending | |
| `SubclassedFromCoreClass` | `Reek/SubclassedFromCoreClass` | pending | `Lint/InheritException` (partial) |
| `TooManyConstants` | `Reek/TooManyConstants` | pending | |
| `TooManyInstanceVariables` | `Reek/TooManyInstanceVariables` | pending | |
| `TooManyMethods` | `Reek/TooManyMethods` | pending | |
| `TooManyStatements` | `Reek/TooManyStatements` | pending | `Metrics/MethodLength` |
| `UncommunicativeMethodName` | `Reek/UncommunicativeMethodName` | pending | `Naming/MethodName` |
| `UncommunicativeModuleName` | `Reek/UncommunicativeModuleName` | pending | `Naming/ClassAndModuleCamelCase` |
| `UncommunicativeParameterName` | `Reek/UncommunicativeParameterName` | pending | `Naming/MethodParameterName` |
| `UncommunicativeVariableName` | `Reek/UncommunicativeVariableName` | pending | `Naming/VariableName` |
| `UnusedParameters` | `Reek/UnusedParameters` | pending | `Lint/UnusedMethodArgument` |
| `UnusedPrivateMethod` | `Reek/UnusedPrivateMethod` | pending | |
| `UtilityFunction` | `Reek/UtilityFunction` | pending | |

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Run the full test suite and linter:

```bash
bundle exec rake
```

Run only the tests:

```bash
bundle exec rake spec
```

Generate a new cop scaffold:

```bash
bundle exec rake new_cop[Reek/CopName]
```

This writes the cop source file, spec, registers it in `lib/rubocop/cop/reek_cops.rb`, and adds an entry to `config/default.yml`.

You can also run `bin/console` for an interactive prompt to experiment with the gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/rubocop/reek/version.rb`, then run `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andyw8/rubocop-reek.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
