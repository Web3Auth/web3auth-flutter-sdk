# openlogin_flutter

Flutter SDK for Torus Web3Auth (OpenLogin)

## Installation

```yml
dependencies:
  openlogin_flutter:
    git: https://github.com/torusresearch/openlogin-flutter-sdk.git
```

Please refer to the native SDKs for platform-specific configuration.

- [Android SDK](https://github.com/torusresearch/openlogin-android-sdk)
- [iOS SDK](https://github.com/torusresearch/openlogin-swift-sdk)

For iOS, the redirectUrl parameter is fixed, which is `\(bundleId)://auth`, and does not need to be added as a iOS Custom URL Scheme.

For Android, the redirectUrl parameter is specificable, and has to be added into the AndroidManifest.xml.

## Usage

Refer to the demo app for more detailed example.

```dart
// Login
final OpenLoginResponse response = await OpenloginFlutter.triggerLogin(provider: Provider.google);

// Logout
await OpenloginFlutter.triggerLogout();

```

## License

MIT