#!/bin/bash

# Скрипт для подготовки и сборки Boombapdap под Android
# Требуется установленный Flutter SDK, Rust (с таргетами aarch64-linux-android) и Android NDK

echo "🚀 Starting Boombapdap Android Build Process..."

# 1. Генерация моста Flutter <-> Rust
echo "🛠 Generating Rust Bridge..."
./generate_bridge.sh

# 2. Сборка Rust библиотеки под Android архитектуры
echo "🦀 Compiling Rust core for Android (arm64)..."
cd rust_core
# Добавляем таргет если нет
rustup target add aarch64-linux-android
# Сборка
cargo build --target aarch64-linux-android --release
cd ..

# 3. Копирование нативной библиотеки в проект Flutter
echo "📂 Copying native libraries..."
mkdir -p app_flutter/android/app/src/main/jniLibs/arm64-v8a
cp rust_core/target/aarch64-linux-android/release/librust_core.so app_flutter/android/app/src/main/jniLibs/arm64-v8a/

# 4. Сборка APK
echo "📱 Building Flutter APK..."
cd app_flutter
flutter build apk --release

echo "✅ Done! APK is located at: app_flutter/build/app/outputs/flutter-apk/app-release.apk"
