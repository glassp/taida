# Modules

## Core Modules
Core Modules are Modules that have their source-code within this package/repository
They are always registered (unless directly unregisterd before sealing)

## Module Loading
The modules are loaded from the ModuleLoader via `ModuleLoader.registerModules` after that call the modules will be sealed and cannot be modified anymore.
This call should only ever be invoked by the ModuleRunner (taida internal).
You can use `ModuleLoader.peek()` to see the currently registered Modules. Be aware Module loading is not ordered and race conditions may occur even if the calls themself are syncronous.

Each Module must implement/extend the Module class. Modules must also not depend on another module within the same executionPhase defined by `Module.executionTime`.