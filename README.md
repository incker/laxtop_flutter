# laxtop

A new Laxtop Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Debug

Debug firebase login:
```
3809519703331
253647
```

## Build release

Full [build documentation](https://flutter.dev/docs/deployment/android)

1. Ensure api url is `https://laxtop.com/`
2. Ensure you have key in keystore `C:\Users\incker\key.jks`
3. build:
```shell script
cd laxtop
flutter build apk --release
```
Release file in `<app dir>/build/app/outputs/apk/release/app-release.apk`

4. Upload release file to [play.google.com/console](https://play.google.com/console)
