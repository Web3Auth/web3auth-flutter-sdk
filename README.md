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

- For iOS, only iOS 12+ supported since we requires ASWebAuthenticationSession.
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
  web3auth_flutter: ^3.1.5
```

or

```sh
flutter pub add web3auth_flutter
```

## 🌟 Configuration

Checkout [SDK Reference](https://web3auth.io/docs/sdk/pnp/flutter/install) to configure for Android and iOS
builds.

#### Register the URL scheme you intended to use for redirection

- Android `AndroidManifest.xml` (required)

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

Checkout the examples for your preferred blockchain and platform in our [examples](https://web3auth.io/docs/examples)

```dart
// Initialization
Future<void> initPlatformState() async {
  final themeMap = HashMap<String, String>();
  themeMap['primary'] = "#fff000";

  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(
      'torusapp://org.torusresearch.flutter.web3authexample/auth',
    );
  } else if (Platform.isIOS) {
    redirectUrl =
        Uri.parse('torusapp://org.torusresearch.flutter.web3authexample');
  } else {
    throw UnKnownException('Unknown platform');
  }
  
  await Web3AuthFlutter.init(
    Web3AuthOptions(
      clientId:
          'BHgArYmWwSeq21czpcarYh0EVq2WWOzflX-NTK-tY1-1pauPzHKRRLgpABkmYiIV_og9jAvoIxQ8L3Smrwe04Lw',
      network: Network.sapphire_devnet,
      redirectUrl: redirectUrl,
      whiteLabel: WhiteLabelData(
        mode: ThemeModes.dark,
        appName: "Web3Auth Flutter App",
        theme: themeMap,
      ),
    ),
  );

  // Call initialize() function to get privKey and user information without relogging in user if a user has an active session
  await Web3AuthFlutter.initialize();

  // Call getPrivKey() function to get user private key
  final String privKey = await Web3AuthFlutter.getPrivKey();

  // Call getEd25519PrivKey() function to get user ed25519 private key
  final String ed255199PrivKey = await Web3AuthFlutter.getEd25519PrivKey();

  // Call getUserInfo() function to get user information like name, email, verifier, verifierId etc.
  final TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();

}

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
      Web3AuthFlutter.setResultUrl();
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

## 🩹 Custom JWT - Example

```dart
// Initialization
Future<void> initPlatformState() async {
  final themeMap = HashMap<String, String>();
  themeMap['primary'] = "#fff000";

  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse(
      'torusapp://org.torusresearch.flutter.web3authexample/auth',
    );
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

   await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId:
            'BHgArYmWwSeq21czpcarYh0EVq2WWOzflX-NTK-tY1-1pauPzHKRRLgpABkmYiIV_og9jAvoIxQ8L3Smrwe04Lw',
        network: Network.sapphire_devnet,
        redirectUrl: redirectUrl,
        whiteLabel: WhiteLabelData(
          mode: ThemeModes.dark,
          appName: "Web3Auth Flutter App",
          theme: themeMap,
        ),
        loginConfig: loginConfig,
      ),
    );

  // Call initialize() function to get privKey and user information without relogging in user if a user has an active session
  await Web3AuthFlutter.initialize();

  // call getPrivKey() function to get user private key
  final String privKey = await Web3AuthFlutter.getPrivKey();

  // call getEd25519PrivKey() function to get user ed25519 private key
  final String ed255199PrivKey = await Web3AuthFlutter.getEd25519PrivKey();

  // call getUserInfo() function to get user information like name, email, verifier, verifierId etc
  final TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
}

// Login
await Web3AuthFlutter.login(
   LoginParams(
    loginProvider: Provider.jwt,
    extraLoginOptions: ExtraLoginOptions(
      id_token: "{YOUR_JWT_TOKEN}",
      domain: "{YOUR-DOMAIN}",
    ),
  ),
);

// Logout
await Web3AuthFlutter.logout();

```

## 🌐 Demo

Checkout the [Web3Auth Demo](https://demo-app.web3auth.io/) to see how Web3Auth can be used in an application.

Have a look at our [Web3Auth PnP Flutter Quick Start](https://web3auth.io/docs/quick-start?product=PNP&sdk=PNP_FLUTTER&framework=IOS&stepIndex=0) to help you quickly integrate a basic instance of Web3Auth Plug and Play in your Flutter app.

Further checkout the [example folder](https://github.com/Web3Auth/web3auth-flutter-sdk/tree/master/example) within this repository, which contains a sample app.

## 💬 Troubleshooting and Support

- Have a look at our [Community Portal](https://community.web3auth.io/) to see if anyone has any questions or issues you might be having. Feel free to create new topics and we'll help you out as soon as possible.
- Checkout our [Troubleshooting Documentation Page](https://web3auth.io/docs/troubleshooting) to know the common issues and solutions.
- For Priority Support, please have a look at our [Pricing Page](https://web3auth.io/pricing.html) for the plan that suits your needs.
