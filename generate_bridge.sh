#!/bin/bash

# Скрипт для генерации связующего кода Flutter <-> Rust
# Требуется установленный flutter_rust_bridge_codegen:
# cargo install flutter_rust_bridge_codegen

echo "Generating Flutter Rust Bridge code..."

flutter_rust_bridge_codegen generate \
    --rust-input rust_core/src/api.rs \
    --dart-output app_flutter/lib/src/rust/frb_generated.dart \
    --rust-output rust_core/src/frb_generated.rs

echo "Done!"
