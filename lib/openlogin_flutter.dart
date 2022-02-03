import 'dart:async';

import 'package:flutter/services.dart';

enum Network { mainnet, testnet }

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
  email_passwordless
}

class LoginParams {
  final Provider loginProvider;
  final bool? reLogin;
  final bool? skipTKey;
  final ExtraLoginOptions? extraLoginOptions;
  final Uri? redirectUrl;
  final String? appState;

  LoginParams({
    required this.loginProvider,
    this.reLogin,
    this.skipTKey,
    this.extraLoginOptions,
    this.redirectUrl,
    this.appState
  });
}

class ExtraLoginOptions {
  final Map? additionalParams;
  final String? domain;
  final String? client_id;
  final String? leeway;
  final String? verifierIdField;
  final bool? isVerifierIdCaseSensitive;
  final String? max_age;
  final String? ui_locales;
  final String? id_token_hint;
  final String? login_hint;
  final String? acr_values;
  final String? scope;
  final String? audience;
  final String? connection;
  final String? state;
  final String? response_type;
  final String? nonce;

  ExtraLoginOptions({
    this.additionalParams = const {},
    this.domain,
    this.client_id,
    this.leeway,
    this.verifierIdField,
    this.isVerifierIdCaseSensitive,
    this.max_age,
    this.ui_locales,
    this.id_token_hint,
    this.login_hint,
    this.acr_values,
    this.scope,
    this.audience,
    this.connection,
    this.state,
    this.response_type,
    this.nonce
  });
}

class OpenLoginOptions {
  final String clientId;
  final Network network;
  final Uri? redirectUrl;
  final String? sdkUrl;

  OpenLoginOptions({
    required this.clientId,
    required this.network,
    this.redirectUrl,
    this.sdkUrl
  });
}

class OpenLoginResponse {
  final String privKey;
  final TorusUserInfo userInfo;
  final String? error;

  OpenLoginResponse(
      this.privKey,
      this.userInfo,
      this.error
      );

  @override
  String toString() {
    return "{privKey=$privKey, userInfo = ${userInfo.toString()}}";
  }
}

class TorusUserInfo {
  final String? email;
  final String? name;
  final String? profileImage;
  final String? verifier;
  final String? verifierId;
  final String? typeOfLogin;
  final String? aggregateVerifier;

  const TorusUserInfo({
    required this.email,
    required this.name,
    this.profileImage,
    this.verifier,
    this.verifierId,
    this.typeOfLogin,
    this.aggregateVerifier,
  });

  @override
  String toString() {
    return "{email=$email, name=$name, profileImage=$profileImage, verifier=$verifier,"
        "verifierId=$verifierId, typeOfLogin=$typeOfLogin}";
  }
}

class UserCancelledException implements Exception {}

class UnKnownException implements Exception {
  final String? message;

  UnKnownException(
      this.message
      );
}

class OpenloginFlutter {
  static const MethodChannel _channel = MethodChannel('openlogin_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
