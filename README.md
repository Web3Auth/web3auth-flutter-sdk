# Web3Auth Flutter SDK

Web3Auth is where passwordless auth meets non-custodial key infrastructure for Web3 apps and wallets. By aggregating OAuth (Google, Twitter, Discord) logins, different wallets and innovative Multi Party Computation (MPC) - Web3Auth provides a seamless login experience to every user on your application.

## 📖 Documentation

Checkout the official [Web3Auth Documentation](https://web3auth.io/docs) and [SDK Reference](https://web3auth.io/docs/sdk/flutter/) to get started!

## 💡 Features
- Plug and Play, OAuth based Web3 Authentication Service
- Fully decentralized, non-custodial key infrastructure
- End to end Whitelabelable solution
- Threshold Cryptography based Key Reconstruction
- Multi Factor Authentication Setup & Recovery (Includes password, backup phrase, device factor editing/deletion etc)
- Support for WebAuthn & Passwordless Login
- Support for connecting to multiple wallets
- DApp Active Session Management

...and a lot more

## ⏪ Requirements

- For iOS, only iOS 12+ supported since we requires ASWebAuthenticationSession.

- For Android, API version 21 or newer.

## ⚡ Installation

```yml
dependencies:
  web3auth_flutter: ^1.0.1
```

or

```sh
flutter pub add web3auth_flutter
```

## 🌟 Configuration

Add `web3auth_flutter` as a dependency to your `pubspec.yaml`

```yaml
dependencies:
  web3auth_flutter: ^1.1.0
    git: https://github.com/torusresearch/web3auth-flutter-sdk.git
```

#### Android

- Perform the native [Android integration steps](https://web3auth.io/docs/sdk/android/).
- For Android, the `redirectUrl` parameter is configurable, and has to be added into the `AndroidManifest.xml`.

#### iOS

- Perform the native [iOS integration steps](https://web3auth.io/docs/sdk/ios/).

- You may add the `redirectUrl`, which is `\(bundleId)://auth`  and does not need to be added as a iOS Custom URL Scheme

#### Register the URL scheme you intended to use for redirection

- Android `AndoidManifest.xml` (required)
- iOS `Info.plist` (optional)

## 🩹 Examples

Checkout the examples for your preferred blockchain and platform in our [examples repository](https://github.com/Web3Auth/examples/)

## 🌐 Demo

Checkout the [Web3Auth Demo](https://demo-app.web3auth.io/) to see how Web3Auth can be used in an application.

Further checkout the [example folder](https://github.com/Web3Auth/web3auth-flutter-sdk/tree/master/example) within this repository, which contains a sample app.

## 💬 Troubleshooting and Discussions

- Have a look at our [GitHub Discussions](https://github.com/Web3Auth/Web3Auth/discussions?discussions_q=sort%3Atop) to see if anyone has any questions or issues you might be having.
- Checkout our [Troubleshooting Documentation Page](https://web3auth.io/docs/troubleshooting) to know the common issues and solutions
- Join our [Discord](https://discord.gg/web3auth) to join our community and get private integration support or help with your integration.
