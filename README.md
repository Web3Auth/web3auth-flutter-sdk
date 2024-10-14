# Web3Auth Flutter SDK

Web3Auth is where passwordless auth meets non-custodial key infrastructure for Web3 apps and wallets. By aggregating OAuth (Google, Twitter, Discord) logins, different wallets and innovative Multi Party Computation (MPC) - Web3Auth provides a seamless login experience to every user on your application.

## 📖 Documentation

Checkout the official [Web3Auth Documentation](https://web3auth.io/docs) and [SDK Reference](https://web3auth.io/docs/sdk/pnp/flutter) to get started!

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

- For iOS, only iOS 14+ supported since we requires ASWebAuthenticationSession.
  - Xcode 11.4+ / 12.x
  - Swift 4.x / 5.x
  - For iOS build: `platform :ios` needs to be `14.0`. Check `ios/Podfile` in
    your Flutter project to change it.
- For Android, API version 24 or newer is supported.
  - For Android build: compileSdkVersion needs to be 34.
  - Check `android/app/build.gradle` in your Flutter project to change it.

## ⚡ Installation

Add `web3auth_flutter` as a dependency to your `pubspec.yaml` file.

```yml
dependencies:
  web3auth_flutter: ^5.0.4
```

or

```sh
flutter pub add web3auth_flutter
```

## 🌟 Configuration

Checkout [SDK Reference](https://web3auth.io/docs/sdk/pnp/flutter/install) to configure for Android and iOS
builds.

## 🩹 Example

Checkout the examples for your preferred blockchain and platform in our [examples](https://web3auth.io/docs/examples)

```dart
// Initialization
await Web3AuthFlutter.init(
  Web3AuthOptions(
    // Get your client it from dashboard.web3auth.io
    clientId: 'YOUR_WEB3AUTH_CLIENT_ID',
    network: Network.sapphire_devnet,
    // Your redirect url, check how to configure.
    // Android: https://web3auth.io/docs/sdk/pnp/flutter/install#android-configuration
    // iOS: https://web3auth.io/docs/sdk/pnp/flutter/install#ios-configuration
    redirectUrl: redirectUrl,
  ),
);

// Call initialize() function to get privKey and user information without relogging in
// user if a user has an active session. If no active session is present, the 
// function throws an error. 
await Web3AuthFlutter.initialize();

// Login
await Web3AuthFlutter.login(LoginParams(loginProvider: Provider.google));

// Logout
await Web3AuthFlutter.logout();
```

## Triggering UserCancellation on Android

On Android, if you want to trigger exception for user closing the browser tab, you have to use
`WidgetsBindingObserver` mixin with your your login screen.

```dart
class LoginScreen extends State<MyApp> with WidgetsBindingObserver {
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    // This is important to trigger the user cancellation on Android.
    if (state == AppLifecycleState.resumed) {
      Web3AuthFlutter.setCustomTabsClosed();
    }
  }
  
   @override
  Widget build(BuildContext context) { 
    // Your UI code
  }
  Future<void> _login() async {
    try {
      await Web3AuthFlutter.login(LoginParams(loginProvider: Provider.google));
    } on UserCancelledException {
        log("User cancelled.");
    } on UnKnownException {
        log("Unknown exception occurred");
    } catch (e) {
        log(e.toString());
    }
  }
}
```

## 🌐 Demo

Checkout the [Web3Auth Demo](https://demo-app.web3auth.io/) to see how Web3Auth can be used in an application.

Have a look at our [Web3Auth PnP Flutter Quick Start](https://web3auth.io/docs/quick-start?product=PNP&sdk=PNP_FLUTTER&framework=IOS&stepIndex=0) to help you quickly integrate a basic instance of Web3Auth Plug and Play in your Flutter app.

Further checkout the [example folder](https://github.com/Web3Auth/web3auth-flutter-sdk/tree/master/example) within this repository, which contains a sample app.

## 💬 Troubleshooting and Support

- Have a look at our [Community Portal](https://community.web3auth.io/) to see if anyone has any questions or issues you might be having. Feel free to create new topics and we'll help you out as soon as possible.
- Checkout our [Troubleshooting Documentation Page](https://web3auth.io/docs/troubleshooting) to know the common issues and solutions.
- For Priority Support, please have a look at our [Pricing Page](https://web3auth.io/pricing.html) for the plan that suits your needs.
