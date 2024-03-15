enum Network { mainnet, testnet, cyan, aqua, sapphire_devnet, sapphire_mainnet }

enum BuildEnv { production, staging, testing }

enum ChainNamespace { eip155, solana }

enum Language { en, de, ja, ko, zh, es, fr, pt, nl }

enum ThemeModes { light, dark, auto }

enum Provider {
  google,
  facebook,
  reddit,
  discord,
  twitch,
  github,
  apple,
  linkedin,
  twitter,
  line,
  kakao,
  email_passwordless,
  jwt
}

enum TypeOfLogin {
  google,
  facebook,
  reddit,
  discord,
  twitch,
  github,
  apple,
  kakao,
  linkedin,
  twitter,
  weibo,
  wechat,
  line,
  email_passwordless,
  email_password,
  jwt
}

enum Display {
  /// Displays the UI with a full page view.
  page,

  /// Displays the UI with a popup window.
  popup,

  /// Displays the UI in a way that leverages a touch interface.
  touch,

  /// Displays the UI with a "feature phone" type interface.
  wap,
}

enum MFALevel {
  /// Presents the MFA screen every third login.
  DEFAULT,
  /// Presents the MFA screen on every login, but user can skip it.
  OPTIONAL,
  /// Make it mandatory for users to set up MFA after login.
  MANDATORY,
  /// Skips the MFA setup screen.
  NONE,
}

extension MFALevelExtension on MFALevel {
  String get type {
    switch (this) {
      case MFALevel.DEFAULT:
        return "default";
      case MFALevel.OPTIONAL:
        return "optional";
      case MFALevel.MANDATORY:
        return "mandatory";
      case MFALevel.NONE:
        return "none";
      default:
        return "default";
    }
  }
}

enum Prompt {
  /// Do not prompt user for login or consent on re-authentication.
  none,

  /// Prompt user for re-authentication.
  login,

  /// Prompt user for consent before processing request.
  consent,

  /// Prompt user to select an account.
  select_account,
}

enum Curve { secp256k1, ed25519 }
