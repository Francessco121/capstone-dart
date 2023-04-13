# capstone-dart
Dart FFI bindings for the [Capstone disassembler framework](https://www.capstone-engine.org/).

> This project is a work-in-progress and really only contains unsafe automatically generated bindings via [ffigen](https://pub.dev/packages/ffigen) at the moment.

## Usage
See [example/example.dart](example/example.dart) for a simple how-to.

## Development

### Regenerating bindings

1. Install LLVM (see the [ffigen docs](https://pub.dev/packages/ffigen#installing-llvm) on this).
2. (If necessary) update the capstone submodule to the latest stable tag.
3. Run `dart run ffigen`.
