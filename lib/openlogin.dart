import 'dart:async';
import 'dart:ffi';

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
  final Bool? reLogin;
  final Bool? skipTKey;
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
  final Bool? isVerifierIdCaseSensitive;
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

class Openlogin {
  static const MethodChannel _channel = MethodChannel('openlogin');

  static Future<void> init({
    required String clientId,
    required Network network,
    required String redirectUri
  }) async {
    final String networkString = network.toString();
    await _channel.invokeMethod('init', {
      'network': networkString.substring(networkString.lastIndexOf('.') + 1),
      'redirectUri': redirectUri,
      'clientId': clientId
    });
  }

  static Future<OpenLoginResponse> triggerLogin({
    required Provider provider,
    String? appState,
    bool? reLogin,
    String? redirectUrl,
    bool? skipTKey,
    String? client_id,
    String? connection,
    String? domain,
    String? id_token_hint,
    String? login_hint,
    Map jwtParams = const {},
  }) async {
    try {
      final Map loginResponse = await _channel.invokeMethod('triggerLogin', {
        'provider':provider.toString().substring(provider.toString().lastIndexOf('.') + 1),
        'appState':appState,
        'reLogin':reLogin,
        'redirectUrl':redirectUrl,
        'skipTKey':skipTKey,
        'client_id':client_id,
        'connection':connection,
        'domain':domain,
        'id_token_hint':id_token_hint,
        'login_hint':login_hint
      });
      return OpenLoginResponse(
        loginResponse['privateKey'],
        _convertUserInfo(loginResponse['userInfo']).first,
        loginResponse['error']
      );
    } on PlatformException catch (e) {
      switch (e.code) {
        case "UserCancelledException":
          throw UserCancelledException();
        case "NoAllowedBrowserFoundException":
          throw UnKnownException(e.message);
        default:
          throw e;
      }
    }
  }

  static Future<void> triggerLogout() async {
    try {
      await _channel.invokeMethod('triggerLogout', {});
      return;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "UserCancelledException":
          throw UserCancelledException();
        case "NoAllowedBrowserFoundException":
          throw UnKnownException(e.message);
        default:
          throw e;
      }
    }
  }


  static List<TorusUserInfo> _convertUserInfo(dynamic obj) {
    if (obj == null) {
      return [];
    }
    if (obj is List<dynamic>) {
      return obj
          .whereType<Map>()
          .map((e) => TorusUserInfo(
        email: e['email'],
        name: e['name'],
        profileImage: e['profileImage'],
        verifier: e['verifier'],
        verifierId: e['verifierId'],
        typeOfLogin: e['typeOfLogin']
      ))
          .toList();
    }
    if (obj is Map) {
      final Map e = obj;
      return [
        TorusUserInfo(
          email: e['email'],
          name: e['name'],
          profileImage: e['profileImage'],
          verifier: e['verifier'],
          verifierId: e['verifierId'],
          typeOfLogin: e['typeOfLogin']
        )
      ];
    }
    throw Exception("incorrect userInfo format");
  }
}
