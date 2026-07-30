@echo off
echo 🚀 Starting Boombapdap Android Build Process for Windows...

:: 1. Генерация моста
echo 🛠 Generating Rust Bridge...
call flutter_rust_bridge_codegen generate --rust-input rust_core/src/api.rs --dart-output app_flutter/lib/src/rust/frb_generated.dart --rust-output rust_core/src/frb_generated.rs

:: 2. Сборка Rust
echo 🦀 Compiling Rust core for Android (arm64)...
cd rust_core
call rustup target add aarch64-linux-android
call cargo build --target aarch64-linux-android --release
cd ..

:: 3. Копирование библиотек
echo 📂 Copying native libraries...
if not exist "app_flutter\android\app\src\main\jniLibs\arm64-v8a" mkdir "app_flutter\android\app\src\main\jniLibs\arm64-v8a"
copy "rust_core\target\aarch64-linux-android\release\librust_core.so" "app_flutter\android\app\src\main\jniLibs\arm64-v8a\"

:: 4. Сборка Flutter
echo 📱 Building Flutter APK...
cd app_flutter
call flutter build apk --release --target-platform android-arm64

echo ✅ Done! APK is located at: app_flutter\build\app\outputs\flutter-apk\app-release.apk
pause
