# web3auth_flutter

Flutter SDK for Torus Web3Auth (Web3Auth)

## Installation

```yml
dependencies:
  web3auth_flutter:
    git: https://github.com/torusresearch/web3auth-flutter-sdk.git
```

Please refer to the native SDKs for platform-specific configuration.

- [Android SDK](https://github.com/torusresearch/web3auth-android-sdk)
- [iOS SDK](https://github.com/torusresearch/web3auth-swift-sdk)

For iOS, the redirectUrl parameter is fixed, which is `\(bundleId)://auth`, and does not need to be added as a iOS Custom URL Scheme.

For Android, the redirectUrl parameter is specificable, and has to be added into the AndroidManifest.xml.

## Usage

Refer to the demo app for more detailed example.

```dart
// Login
final Web3AuthResponse response = await Web3AuthFlutter.login(provider: Provider.google);

// Logout
await Web3AuthFlutter.logout();

```

## License

MIT