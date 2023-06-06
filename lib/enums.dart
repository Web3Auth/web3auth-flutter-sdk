enum Network { mainnet, testnet, cyan, aqua }

enum ChainNamespace { eip155, solana }

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

enum Display { page, popup, touch, wap }

enum MFALevel { DEFAULT, OPTIONAL, MANDATORY, NONE }

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

enum Prompt { none, login, consent, select_account }

enum Curve { secp256k1, ed25519 }
