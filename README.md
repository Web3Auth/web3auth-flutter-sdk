# Web3Auth Flutter SDK

Web3Auth is where passwordless auth meets non-custodial key infrastructure for
Web3 apps and wallets. By aggregating OAuth (Google, Twitter, Discord) logins,
different wallets and innovative Multi Party Computation (MPC) - Web3Auth
provides a seamless login experience to every user on your application.

## 📖 Documentation

Checkout the official [Web3Auth Documentation](https://web3auth.io/docs) and
[SDK Reference](https://web3auth.io/docs/sdk/flutter/) to get started!

## 💡 Features

- Plug and Play, OAuth based Web3 Authentication Service
- Fully decentralized, non-custodial key infrastructure
- End to end Whitelabelable solution
- Threshold Cryptography based Key Reconstruction
- Multi Factor Authentication Setup & Recovery (Includes password, backup
  phrase, device factor editing/deletion etc)
- Support for WebAuthn & Passwordless Login
- Support for connecting to multiple wallets
- DApp Active Session Management

...and a lot more

## ⏪ Requirements

- For iOS, only iOS 12+ supported since we requires ASWebAuthenticationSession.
  - Xcode 11.4+ / 12.x
  - Swift 4.x / 5.x
  - For iOS build: `platform :ios` needs to be `13.0`. Check `ios/Podfile` in
    your Flutter project to change it.
- For Android, API version 24 or newer is supported.
  - For Android build: compileSdkVersion needs to be 32.
  - Check `android/app/build.gradle` in your Flutter project to change it.

## ⚡ Installation

Add `web3auth_flutter` as a dependency to your `pubspec.yaml` file.

```yml
dependencies:
  web3auth_flutter: ^1.2.0
```

or

```sh
flutter pub add web3auth_flutter
```

## 🌟 Configuration

Checkout https://web3auth.io/docs/sdk/flutter to configure for Android and iOS
builds.

#### Register the URL scheme you intended to use for redirection

- Android `AndoidManifest.xml` (required)

  ```xml
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />

    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <data android:scheme="{scheme}" android:host="{YOUR_APP_PACKAGE_NAME}" android:path="/auth" />
    <!-- Accept URIs: w3a://com.example.w3aflutter/auth -->
  </intent-filter>
  ```

- iOS `Info.plist` (optional)

## 🩹 Example

```dart
// Initialization
Future<void> initPlatformState() async {
  final themeMap = HashMap<String, String>();
  themeMap['primary'] = "#fff000";

  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(
        'torusapp://org.torusresearch.flutter.web3authexample/auth');
  } else if (Platform.isIOS) {
    redirectUrl =
        Uri.parse('torusapp://org.torusresearch.flutter.web3authexample');
  } else {
    throw UnKnownException('Unknown platform');
  }

  await Web3AuthFlutter.init(Web3AuthOptions(
      clientId:
          'BCtbnOamqh0cJFEUYA0NB5YkvBECZ3HLZsKfvSRBvew2EiiKW3UxpyQASSR0artjQkiUOCHeZ_ZeygXpYpxZjOs',
      network: Network.cyan,
      redirectUrl: redirectUrl,
      whiteLabel: WhiteLabelData(
          dark: true, name: "Web3Auth Flutter App", theme: themeMap)));
}

// Login
final Web3AuthResponse response = await Web3AuthFlutter.login(LoginParams(loginProvider: Provider.google));

// Logout
await Web3AuthFlutter.logout();

```

## 🩹 Custom JWT - Example

```dart
// Initialization
Future<void> initPlatformState() async {
  final themeMap = HashMap<String, String>();
  themeMap['primary'] = "#fff000";

  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(
        'torusapp://org.torusresearch.flutter.web3authexample/auth');
  } else if (Platform.isIOS) {
    redirectUrl =
        Uri.parse('torusapp://org.torusresearch.flutter.web3authexample');
  } else {
    throw UnKnownException('Unknown platform');
  }

  final loginConfig = new HashMap<String, LoginConfigItem>();
  loginConfig['jwt'] = LoginConfigItem(
    verifier: "verifier-name", // get it from web3auth dashboard
    typeOfLogin: TypeOfLogin.jwt,
    name: "Custom JWT Login",
    clientId: "web3auth_client_id" // web3auth's plug and play client id
  );

  await Web3AuthFlutter.init(Web3AuthOptions(
      clientId:
          'BCtbnOamqh0cJFEUYA0NB5YkvBECZ3HLZsKfvSRBvew2EiiKW3UxpyQASSR0artjQkiUOCHeZ_ZeygXpYpxZjOs',
      network: Network.cyan,
      redirectUrl: redirectUrl,
      whiteLabel: WhiteLabelData(
          dark: true, name: "Web3Auth Flutter App", theme: themeMap),
      loginConfig: loginConfig));
}

// Login
final Web3AuthResponse response = await Web3AuthFlutter.login(LoginParams(
  loginProvider: Provider.jwt,
  extraLoginOptions: ExtraLoginOptions(
      id_token: "{YOUR_JWT_TOKEN}", domain: "{YOUR-DOMAIN}")
));

// Logout
await Web3AuthFlutter.logout();

```

## 🌐 Demo

Checkout the [Web3Auth Demo](https://demo-app.web3auth.io/) to see how Web3Auth
can be used in an application.

Further checkout the
[example folder](https://github.com/Web3Auth/web3auth-flutter-sdk/tree/master/example)
within this repository, which contains a sample app.

## 💬 Troubleshooting and Discussions

- Have a look at our
  [Community Portal](https://community.web3auth.io/c/help-pnp/pnp-flutter/18)
  to see if anyone has any questions or issues you might be having.
- Checkout our
  [Troubleshooting Documentation Page](https://web3auth.io/docs/troubleshooting)
  to know the common issues and solutions
- Join our [Discord](https://discord.gg/web3auth) to join our community and get
  private integration support or help with your integration.
