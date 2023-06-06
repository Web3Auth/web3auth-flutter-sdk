import 'dart:collection';

import 'package:web3auth_flutter/enums.dart';

class LoginParams {
  final Provider loginProvider;
  final String? dappShare;
  final int? sessionTime;
  final Curve? curve;
  final ExtraLoginOptions? extraLoginOptions;
  final Uri? redirectUrl;
  final String? appState;
  final MFALevel? mfaLevel;

  LoginParams(
      {required this.loginProvider,
      this.dappShare,
      this.sessionTime,
      this.curve,
      this.extraLoginOptions,
      this.redirectUrl,
      this.appState,
      this.mfaLevel});

  Map<String, dynamic> toJson() => {
        "loginProvider": loginProvider.name,
        "dappShare": dappShare,
        "sessionTime": sessionTime,
        "curve": curve?.name,
        "extraLoginOptions": extraLoginOptions?.toJson(),
        "redirectUrl": redirectUrl?.toString(),
        "appState": appState,
        "mfaLevel": mfaLevel?.type,
      };
}

class LoginConfigItem {
  final String verifier;
  final TypeOfLogin typeOfLogin;
  final String? name;
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
      this.name,
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
      'typeOfLogin': typeOfLogin.name,
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
  final String? id_token;
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
      this.id_token,
      this.login_hint,
      this.acr_values,
      this.scope,
      this.audience,
      this.connection,
      this.state,
      this.response_type,
      this.nonce,
      this.redirect_uri});

  Map<String, dynamic> toJson() => {
        "additionalParams": additionalParams,
        "domain": domain,
        "client_id": client_id,
        "leeway": leeway,
        "verifierIdField": verifierIdField,
        "isVerifierIdCaseSensitive": isVerifierIdCaseSensitive,
        "display": display?.name,
        "prompt": prompt?.name,
        "max_age": max_age,
        "ui_locales": ui_locales,
        "id_token_hint": id_token_hint,
        "id_token": id_token,
        "login_hint": login_hint,
        "acr_values": acr_values,
        "scope": scope,
        "audience": audience,
        "connection": connection,
        "state": state,
        "response_type": response_type,
        "nonce": nonce,
        "redirect_uri": redirect_uri,
      };
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

class Web3AuthOptions {
  final String clientId;
  final Network network;
  final Uri? redirectUrl;
  final WhiteLabelData? whiteLabel;
  final HashMap<String, LoginConfigItem>? loginConfig;
  final bool? useCoreKitKey;
  final ChainNamespace? chainNamespace;

  Web3AuthOptions(
      {required this.clientId,
      required this.network,
      this.redirectUrl,
      this.whiteLabel,
      this.loginConfig,
      this.useCoreKitKey,
      this.chainNamespace});

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'network': network.name,
      'redirectUrl': redirectUrl?.toString(),
      'whiteLabel': whiteLabel?.toJson(),
      'loginConfig': loginConfig,
      'useCoreKitKey': useCoreKitKey,
      'chainNamespace': chainNamespace,
    };
  }
}

class UserCancelledException implements Exception {}

class UnKnownException implements Exception {
  final String? message;

  UnKnownException(this.message);
}
