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
| [`Attribute`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/attribute.rb) | `Reek/Attribute` | pending | `Style/AccessorGrouping` |
| [`BooleanParameter`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/boolean_parameter.rb) | `Reek/BooleanParameter` | pending | |
| [`ClassVariable`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/class_variable.rb) | `Reek/ClassVariable` | pending | |
| [`ControlParameter`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/control_parameter.rb) | `Reek/ControlParameter` | pending | |
| [`DataClump`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/data_clump.rb) | `Reek/DataClump` | pending | |
| [`DuplicateMethodCall`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/duplicate_method_call.rb) | [`Reek/DuplicateMethodCall`](lib/rubocop/cop/reek/duplicate_method_call.rb) | done | |
| [`FeatureEnvy`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/feature_envy.rb) | `Reek/FeatureEnvy` | pending | |
| [`InstanceVariableAssumption`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/instance_variable_assumption.rb) | `Reek/InstanceVariableAssumption` | pending | |
| [`IrresponsibleModule`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/irresponsible_module.rb) | `Reek/IrresponsibleModule` | pending | `Style/Documentation` |
| [`LongParameterList`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/long_parameter_list.rb) | `Reek/LongParameterList` | pending | `Metrics/ParameterLists` |
| [`LongYieldList`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/long_yield_list.rb) | `Reek/LongYieldList` | pending | |
| [`ManualDispatch`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/manual_dispatch.rb) | `Reek/ManualDispatch` | pending | |
| [`MissingSafeMethod`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/missing_safe_method.rb) | `Reek/MissingSafeMethod` | pending | |
| [`ModuleInitialize`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/module_initialize.rb) | `Reek/ModuleInitialize` | pending | |
| [`NestedIterators`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/nested_iterators.rb) | `Reek/NestedIterators` | pending | `Metrics/BlockNesting` |
| [`NilCheck`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/nil_check.rb) | `Reek/NilCheck` | pending | `Style/NilComparison` |
| [`RepeatedConditional`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/repeated_conditional.rb) | `Reek/RepeatedConditional` | pending | |
| [`SubclassedFromCoreClass`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/subclassed_from_core_class.rb) | `Reek/SubclassedFromCoreClass` | pending | `Lint/InheritException` (partial) |
| [`TooManyConstants`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/too_many_constants.rb) | `Reek/TooManyConstants` | pending | |
| [`TooManyInstanceVariables`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/too_many_instance_variables.rb) | `Reek/TooManyInstanceVariables` | pending | |
| [`TooManyMethods`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/too_many_methods.rb) | `Reek/TooManyMethods` | pending | |
| [`TooManyStatements`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/too_many_statements.rb) | `Reek/TooManyStatements` | pending | `Metrics/MethodLength` |
| [`UncommunicativeMethodName`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/uncommunicative_method_name.rb) | `Reek/UncommunicativeMethodName` | pending | `Naming/MethodName` |
| [`UncommunicativeModuleName`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/uncommunicative_module_name.rb) | `Reek/UncommunicativeModuleName` | pending | `Naming/ClassAndModuleCamelCase` |
| [`UncommunicativeParameterName`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/uncommunicative_parameter_name.rb) | `Reek/UncommunicativeParameterName` | pending | `Naming/MethodParameterName` |
| [`UncommunicativeVariableName`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/uncommunicative_variable_name.rb) | `Reek/UncommunicativeVariableName` | pending | `Naming/VariableName` |
| [`UnusedParameters`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/unused_parameters.rb) | `Reek/UnusedParameters` | pending | `Lint/UnusedMethodArgument` |
| [`UnusedPrivateMethod`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/unused_private_method.rb) | `Reek/UnusedPrivateMethod` | pending | |
| [`UtilityFunction`](https://github.com/troessner/reek/blob/master/lib/reek/smell_detectors/utility_function.rb) | `Reek/UtilityFunction` | pending | |

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

In addition to hand-written specs, `spec/reek_specs_spec.rb` runs Reek's original smell detector specs against all implemented cops. These are fetched from GitHub on first run and cached in `tmp/reek_specs/` (gitignored). Delete that directory to force a refresh.

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
