import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:collection';

import 'package:flutter/services.dart';

enum Network { mainnet, testnet, cyan }

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

enum Prompt { none, login, consent, select_account }

class LoginParams {
  final Provider loginProvider;
  final bool? reLogin;
  final bool? skipTKey;
  final ExtraLoginOptions? extraLoginOptions;
  final Uri? redirectUrl;
  final String? appState;

  LoginParams(
      {required this.loginProvider,
      this.reLogin,
      this.skipTKey,
      this.extraLoginOptions,
      this.redirectUrl,
      this.appState});
}

class LoginConfigItem {
  final String verifier;
  final TypeOfLogin typeOfLogin;
  final String name;
  final String? description;
  final String? clientId;
  final String? verifierSubIdentifier;
  final String? logoHover;
  final String? logoLight;
  final String? logoDark;
  final bool? mainOption;
  final bool? showOnModal;
  final bool? showOnDesktop;
  final bool? showOnMobile;

  LoginConfigItem(
      {required this.verifier,
      required this.typeOfLogin,
      required this.name,
      this.description,
      this.clientId,
      this.verifierSubIdentifier,
      this.logoHover,
      this.logoLight,
      this.logoDark,
      this.mainOption,
      this.showOnModal,
      this.showOnDesktop,
      this.showOnMobile});

  Map<String, dynamic> toJson() {
    return {
      'verifier': verifier,
      'typeOfLogin': typeOfLogin.toString(),
      'name': name,
      'description': description,
      'clientId': clientId,
      'verifierSubIdentifier': verifierSubIdentifier,
      'logoHover': logoHover,
      'logoLight': logoLight,
      'logoDark': logoDark,
      'mainOption': mainOption,
      'showOnModal': showOnModal,
      'showOnDesktop': showOnDesktop,
      'showOnMobile': showOnMobile
    };
  }
}

class ExtraLoginOptions {
  final Map? additionalParams;
  final String? domain;
  final String? client_id;
  final String? leeway;
  final String? verifierIdField;
  final bool? isVerifierIdCaseSensitive;
  final Display? display;
  final Prompt? prompt;
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
  final String? redirect_uri;

  ExtraLoginOptions(
      {this.additionalParams = const {},
      this.domain,
      this.client_id,
      this.leeway,
      this.verifierIdField,
      this.isVerifierIdCaseSensitive,
      this.display,
      this.prompt,
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
      this.nonce,
      this.redirect_uri});
}

class Web3AuthOptions {
  final String clientId;
  final Network network;
  final Uri? redirectUrl;
  final String? sdkUrl;

  Web3AuthOptions(
      {required this.clientId,
      required this.network,
      this.redirectUrl,
      this.sdkUrl});
}

class WhiteLabelData {
  final String? name;
  final String? logoLight;
  final String? logoDark;
  final String? defaultLanguage;
  final bool? dark;
  final HashMap? theme;

  WhiteLabelData(
      {this.name,
      this.logoLight,
      this.logoDark,
      this.defaultLanguage,
      this.dark,
      this.theme});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoLight': logoLight,
      'logoDark': logoDark,
      'defaultLanguage': defaultLanguage,
      'dark': dark,
      'theme': theme
    };
  }
}

class Web3AuthResponse {
  final String privKey;
  final TorusUserInfo userInfo;
  final String? error;

  Web3AuthResponse(this.privKey, this.userInfo, this.error);

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
  final String? dappShare;

  const TorusUserInfo({
    required this.email,
    required this.name,
    this.profileImage,
    this.verifier,
    this.verifierId,
    this.typeOfLogin,
    this.aggregateVerifier,
    this.dappShare,
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

  UnKnownException(this.message);
}

class Web3AuthFlutter {
  static const MethodChannel _channel = MethodChannel('web3auth_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> init(
      {required String clientId,
      Network? network,
      required String redirectUri,
      WhiteLabelData? whiteLabelData,
      HashMap? loginConfig}) async {
    final String? networkString = network?.toString();
    await _channel.invokeMethod('init', {
      'network': (networkString != null)
          ? networkString.substring(networkString.lastIndexOf('.') + 1)
          : null,
      'redirectUri': redirectUri,
      'clientId': clientId,
      'white_label_data': jsonEncode(whiteLabelData),
      'login_config': jsonEncode(loginConfig)
    });
  }

  static Future<Web3AuthResponse> login(
      {required Provider provider,
      String? appState,
      bool? relogin,
      String? redirectUrl,
      ExtraLoginOptions? extraLoginOptions}) async {
    try {
      final Map loginResponse = await _channel.invokeMethod('login', {
        'provider': provider
            .toString()
            .substring(provider.toString().lastIndexOf('.') + 1),
        'appState': appState,
        'relogin': relogin,
        'redirectUrl': redirectUrl,
        'additionalParams': extraLoginOptions?.additionalParams,
        'client_id': extraLoginOptions?.client_id,
        'connection': extraLoginOptions?.connection,
        'domain': extraLoginOptions?.domain,
        'id_token_hint': extraLoginOptions?.id_token_hint,
        'login_hint': extraLoginOptions?.login_hint,
        'leeway': extraLoginOptions?.leeway,
        'verifierIdField': extraLoginOptions?.verifierIdField,
        'isVerifierIdCaseSensitive':
            extraLoginOptions?.isVerifierIdCaseSensitive,
        'display': extraLoginOptions?.display.toString(),
        'prompt': extraLoginOptions?.prompt.toString(),
        'max_age': extraLoginOptions?.max_age,
        'ui_locales': extraLoginOptions?.ui_locales,
        'acr_values': extraLoginOptions?.acr_values,
        'scope': extraLoginOptions?.scope,
        'audience': extraLoginOptions?.audience,
        'state': extraLoginOptions?.state,
        'response_type': extraLoginOptions?.response_type,
        'nonce': extraLoginOptions?.nonce,
        'redirect_uri': extraLoginOptions?.redirect_uri
      });
      return Web3AuthResponse(
          loginResponse['privateKey'],
          _convertUserInfo(loginResponse['userInfo']).first,
          loginResponse['error']);
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

  static Future<void> logout() async {
    try {
      await _channel.invokeMethod('logout', {});
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
              dappShare: e['dappShare'],
              aggregateVerifier: e['aggregateVerifier'],
              verifier: e['verifier'],
              verifierId: e['verifierId'],
              typeOfLogin: e['typeOfLogin']))
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
            typeOfLogin: e['typeOfLogin'])
      ];
    }
    throw Exception("incorrect userInfo format");
  }
}
