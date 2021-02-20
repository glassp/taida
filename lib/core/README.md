# taida Internal
## Flow
1. cli/cli.dart registers all Commands (called by /bin/taida.dart)
2. corresponding command gets invoked
3. ConfigurationLoader looks for configuration file in cwd => cwd will be `PROJECT_ROOT`
4. Configuration is copied to working directory
5. Configuration gets parsed by corrsponding ConfigurationParser (determined by file extension matching)
6. ModuleLoader installs javascript dependencies and creates config files for them (via a ugly function that invokes processes and calls various methods from classes in the file directory)
7. ModuleLoader executes Modules in phase  `Module.run(command-name)` by iterating over the `Phase` enum and matching the value with `Module.executionTime`

## Configuration
