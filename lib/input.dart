import 'dart:collection';

import 'package:web3auth_flutter/enums.dart';

class LoginParams {
  final Provider loginProvider;
  final String? dappShare;
  final Curve? curve;
  final ExtraLoginOptions? extraLoginOptions;
  final Uri? redirectUrl;
  final String? appState;
  final MFALevel? mfaLevel;
  final String? dappUrl;

  LoginParams({
    required this.loginProvider,
    this.dappShare,
    this.curve = Curve.secp256k1,
    this.extraLoginOptions,
    this.redirectUrl,
    this.appState,
    this.mfaLevel,
    this.dappUrl
  });

  Map<String, dynamic> toJson() => {
        "loginProvider": loginProvider.name,
        "dappShare": dappShare,
        "curve": curve?.name,
        "extraLoginOptions": extraLoginOptions?.toJson(),
        "redirectUrl": redirectUrl?.toString(),
        "appState": appState,
        "mfaLevel": mfaLevel?.type,
        "dappUrl": dappUrl
      };
}

class LoginConfigItem {
  final String verifier;
  final TypeOfLogin typeOfLogin;
  final String clientId;
  final String? name;
  final String? description;
  final String? verifierSubIdentifier;
  final String? logoHover;
  final String? logoLight;
  final String? logoDark;
  final bool? mainOption;
  final bool? showOnModal;
  final bool? showOnDesktop;
  final bool? showOnMobile;

  LoginConfigItem({
    required this.verifier,
    required this.typeOfLogin,
    required this.clientId,
    this.name,
    this.description,
    this.verifierSubIdentifier,
    this.logoHover,
    this.logoLight,
    this.logoDark,
    this.mainOption,
    this.showOnModal,
    this.showOnDesktop,
    this.showOnMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'verifier': verifier,
      'typeOfLogin': typeOfLogin.name,
      'clientId': clientId,
      'name': name,
      'description': description,
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

  ExtraLoginOptions({
    this.additionalParams = const {},
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
    this.redirect_uri,
  });

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
  final String? appName;
  final String? logoLight;
  final String? logoDark;
  final Language? defaultLanguage;
  final ThemeModes? mode;
  final HashMap? theme;
  final String? appUrl;
  final bool? useLogoLoader;

  WhiteLabelData({
    this.appName,
    this.logoLight,
    this.logoDark,
    this.defaultLanguage = Language.en,
    this.mode = ThemeModes.auto,
    this.theme,
    this.appUrl,
    this.useLogoLoader,
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'logoLight': logoLight,
      'logoDark': logoDark,
      'defaultLanguage': defaultLanguage?.name,
      'mode': mode?.name,
      'theme': theme,
      'appUrl': appUrl,
      'useLogoLoader': useLogoLoader
    };
  }
}

class MfaSetting {
  final bool enable;
  final int? priority;
  final bool? mandatory;

  MfaSetting({required this.enable, this.priority, this.mandatory});

  Map<String, dynamic> toJson() {
    return {'enable': enable, 'priority': priority, 'mandatory': mandatory};
  }
}

class MfaSettings {
  final MfaSetting? deviceShareFactor;
  final MfaSetting? backUpShareFactor;
  final MfaSetting? socialBackupFactor;
  final MfaSetting? passwordFactor;
  final MfaSetting? passkeysFactor;
  final MfaSetting? authenticatorFactor;

  MfaSettings({
    this.deviceShareFactor,
    this.backUpShareFactor,
    this.socialBackupFactor,
    this.passwordFactor,
    this.passkeysFactor,
    this.authenticatorFactor,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceShareFactor': deviceShareFactor,
      'backUpShareFactor': backUpShareFactor,
      'socialBackupFactor': socialBackupFactor,
      'passwordFactor': passwordFactor,
      'passkeysFactor': passkeysFactor,
      'authenticatorFactor': authenticatorFactor
    };
  }
}

class ChainConfig {
  final ChainNamespace? chainNamespace;
  final int decimals;
  final String? blockExplorerUrl;
  final String chainId;
  final String? displayName;
  final String? logo;
  final String rpcTarget;
  final String ticker;
  final String? tickerName;

  ChainConfig({
    this.chainNamespace = ChainNamespace.eip155,
    this.decimals = 18,
    this.blockExplorerUrl,
    required this.chainId,
    this.displayName,
    this.logo,
    required this.rpcTarget,
    required this.ticker,
    this.tickerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'chainNamespace': chainNamespace?.name,
      'decimals': decimals,
      'blockExplorerUrl': blockExplorerUrl,
      'chainId': chainId,
      'displayName': displayName,
      'logo': logo,
      'rpcTarget': rpcTarget,
      'ticker': ticker,
      'tickerName': tickerName
    };
  }
}

class Web3AuthOptions {
  final String clientId;
  final Network network;
  final BuildEnv? buildEnv;
  final String? sdkUrl;
  final String? walletSdkUrl;
  final Uri redirectUrl;
  final WhiteLabelData? whiteLabel;
  final HashMap<String, LoginConfigItem>? loginConfig;
  final bool? useCoreKitKey;
  final ChainNamespace? chainNamespace;
  final MfaSettings? mfaSettings;
  final int? sessionTime;
  final ChainConfig? chainConfig;

  Web3AuthOptions({
    required this.clientId,
    required this.network,
    this.buildEnv = BuildEnv.production,
    String? sdkUrl,
    String? walletSdkUrl,
    required this.redirectUrl,
    this.whiteLabel,
    this.loginConfig,
    this.useCoreKitKey,
    this.chainNamespace = ChainNamespace.eip155,
    this.sessionTime = 86400,
    this.mfaSettings,
    this.chainConfig
  })
      : sdkUrl = sdkUrl ?? getSdkUrl(buildEnv ?? BuildEnv.production),
        walletSdkUrl =
            walletSdkUrl ?? getWalletSdkUrl(buildEnv ?? BuildEnv.production);

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'network': network.name,
      'sdkUrl': sdkUrl,
      'walletSdkUrl': walletSdkUrl,
      'buildEnv': buildEnv?.name,
      'redirectUrl': redirectUrl.toString(),
      'whiteLabel': whiteLabel?.toJson(),
      'loginConfig': loginConfig,
      'useCoreKitKey': useCoreKitKey,
      'chainNamespace': chainNamespace?.name,
      'mfaSettings': mfaSettings,
      "sessionTime": sessionTime,
      "chainConfig": chainConfig?.toJson()
    };
  }
}

class UserCancelledException implements Exception {}

class UnKnownException implements Exception {
  final String? message;

  UnKnownException(this.message);
}

String getSdkUrl(BuildEnv? buildEnv) {
  const String version = "v7";
  switch (buildEnv) {
    case BuildEnv.staging:
      return "https://staging-auth.web3auth.io/$version";
    case BuildEnv.testing:
      return "https://develop-auth.web3auth.io";
    case BuildEnv.production:
    default:
      return "https://auth.web3auth.io/$version";
  }
}

String getWalletSdkUrl(BuildEnv? buildEnv) {
  const String walletServicesVersion = "v1";
  switch (buildEnv) {
    case BuildEnv.staging:
      return "https://staging-wallet.web3auth.io/$walletServicesVersion";
    case BuildEnv.testing:
      return "https://develop-wallet.web3auth.io";
    case BuildEnv.production:
    default:
      return "https://wallet.web3auth.io/$walletServicesVersion";
  }
}
