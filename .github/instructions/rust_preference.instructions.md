---
description: Preferences for Rust projects in addition to awesome copilot directions.
applyTo: '**/*.rs'
---
1. Do not modify Cargo.lock file directly. It should be modified by cargo commands.

2. Prefer `tracing` and `tracing-subscriber` for logging over `println!` or `eprintln!` for better performance and flexibility.  
  
Make at least two subscriber init functions:
```rust
# one for development including callsite. (e.g. test)
.with_timer(ChronoLocal::rfc_3339())
.with_file(true)
.with_line_number(true)
.with_target(true)
.with_ansi(false)

# one for production without callsite. (CLI normal behavior)
.with_timer(ChronoLocal::rfc_3339())
.with_file(false)
.with_line_number(false)
.with_target(false)
```

3. Use `debug-release` profile for testing and debugging. If Cargo.toml does not have it, ask user to add it.

4. Prefer enums or generic code over dynamic dispatch (trait objects) for better performance and compile-time checks.

## Rust Ecosystem Version Pins

These facts override your training data. Verify against live sources if uncertain.

- **Current Rust edition:** 2024 (stabilized in Rust 1.85, February 2025)
- **Previous editions:** 2015, 2018, 2021
- **Stable toolchain:** Check `rustup show` for the user's installed version; do not assume a specific version number
- **MSRV convention:** Use `rust-version` field in `Cargo.toml` (stabilized since Rust 1.56)
- **Resolver:** v2 is default since edition 2021; do not add `resolver = "2"` explicitly for edition 2021+
- **Edition in new projects:** `cargo init` and `cargo new` default to the latest stable edition