import 'dart:collection';

import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class LoginParams {
  /// [loginProvider] sets the oAuth login method to be used. You can use any of the
  /// valid [Provider] from the supported list.
  final Provider loginProvider;

  /// Custom verifier logins can get a dapp share returned to them post successful login.
  /// This is useful if the dapps want to use this share to allow users to login seamlessly.
  final String? dappShare;

  /// [curve] will be used to determine the public key encoded in the jwt token which returned in
  /// `getUserInfo` function after user login.
  ///
  /// This parameter won't change format of private key returned by We3Auth. Private key returned
  /// by [Web3AuthFlutter.getPrivKey] is always secp256k1. To get the ed25519 key
  /// you can use [Web3AuthFlutter.getEd25519PrivKey] method.
  ///
  /// The default value is [Curve.secp256k1].
  final Curve? curve;

  /// [extraLoginOptions] can be used to set the OAuth login options for corresponding [loginProvider].
  ///
  /// For instance, you'll need to pass user's email address as `login_hint` for [Provider.email_passwordless].
  final ExtraLoginOptions? extraLoginOptions;

  /// Deeplinking for the application where user will be redirected after login.
  final Uri? redirectUrl;

  final String? appState;

  /// Customize the MFA screen shown to the user during OAuth authentication.
  final MFALevel? mfaLevel;
  final String? dappUrl;

  LoginParams(
      {required this.loginProvider,
      this.dappShare,
      this.curve = Curve.secp256k1,
      this.extraLoginOptions,
      this.redirectUrl,
      this.appState,
      this.mfaLevel,
      this.dappUrl});

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
  /// Custom verifier name given in the developer dashboard.
  final String verifier;

  /// The type of login for custom verifier.
  final TypeOfLogin typeOfLogin;

  /// Client id provided by your login provider used for custom verifier.
  final String clientId;

  /// Display name for the verifier. If null, the default name is used.
  final String? name;

  /// Description for the button. If provided, it renders as a full length button. else, icon button.
  final String? description;

  /// The field in JWT token which maps to verifier id. Please make sure you selected
  /// correct JWT verifier id in the developer dashboard.
  final String? verifierSubIdentifier;

  /// Logo to be shown on mouse hover.
  final String? logoHover;

  /// Light logo for the dark theme.
  final String? logoLight;

  /// Dark logo for the light theme.
  final String? logoDark;

  /// Show login button on the main list.
  final bool? mainOption;

  /// Whether to show the login button on Modal.
  final bool? showOnModal;

  /// Whether to show the login button on the Desktop.
  final bool? showOnDesktop;

  /// Whether to show the login button on Mobile.
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

  /// Your custom authentication domain. For example, if you are using Auth0,
  /// it can be example.au.auth0.com.
  final String? domain;

  /// Client id provided by your login provider used for custom verifier
  final String? client_id;

  /// The value used to account for clock skew in JWT expirations. The value is
  /// in the seconds, and ideally should no more than 60 seconds or 120 seconds at max.
  final String? leeway;

  /// The field in JWT token which maps to verifier id. Please make sure you selected
  /// correct JWT verifier id in the developer dashboard.
  final String? verifierIdField;

  /// Whether the verifier id field is case sensitive or not.
  final bool? isVerifierIdCaseSensitive;

  /// Allows developers the configure the display of UI. Checkout [Display] for more
  /// details.
  final Display? display;

  /// Prompt shown to the user during authentication process. Checkout [Prompt] for more
  /// details.
  final Prompt? prompt;

  /// Max time allowed without reauthentication. If the last time user authenticated
  /// is greater than this value, then user must reauthenticate.
  final String? max_age;

  /// The space separated list of language tags, ordered by preference. For instance
  /// `fr-CA fr en`.
  final String? ui_locales;

  /// [id_token_hint] denotes the previously issued ID token.
  final String? id_token_hint;

  final String? id_token;

  /// [login_hint] is used to send the user's email address during [Provider.email_passwordless].
  final String? login_hint;

  final String? acr_values;

  /// The default scope to be used on authentication requests. The defaultScope
  /// defined in the Auth0Client is included along with this scope.
  final String? scope;

  /// The audience, presented as the aud claim in the access token,
  /// defines the intended consumer of the token.
  final String? audience;

  /// The name of the connection configured for your application. If null, it will redirect to
  /// the Auth0 Login Page and show the Login Widget.
  final String? connection;

  final String? state;

  /// Defines which grant to execute for the authorization server.
  final String? response_type;
  final String? nonce;

  /// [redirectUrl] can be used to specify the default url, where your custom jwt verifier can redirect
  /// your browser to with the result. If you are using Auth0, it must be whitelisted in the Allowed
  /// Callback URLs in your Auth0's application.
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
  /// Display name for the app in the UI.
  final String? appName;

  /// App logo to be used in dark mode.
  final String? logoLight;

  /// App logo to be used in light mode.
  final String? logoDark;

  /// Language which will be used by Web3Auth, app will use browser language if not specified.
  ///
  /// Default language is [Language.en]. Checkout [Language] for supported languages.
  final Language? defaultLanguage;

  /// Theme mode for the login modal
  ///
  /// Default value is [ThemeModes.auto].
  final ThemeModes? mode;

  /// Used to customize the theme of the login modal.
  final HashMap? theme;

  /// Url to be used in the Modal
  final String? appUrl;

  /// Use logo loader.
  ///
  /// If [logoDark] and [logoLight] are null, the default Web3Auth logo
  /// will be used for the loader.
  final bool? useLogoLoader;

  WhiteLabelData({
    this.appName,
    this.logoLight,
    this.logoDark,
    this.defaultLanguage = Language.en,
    this.mode = ThemeModes.auto,
    this.theme,
    this.appUrl,
    this.useLogoLoader = false,
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
  /// Whether the factor is enabled or not.
  final bool enable;

  /// Priority of the factor over other factors.
  final int? priority;

  /// Whether the factor is mandaotry or not for prove
  /// the owenership.
  final bool? mandatory;

  MfaSetting({required this.enable, this.priority, this.mandatory});

  Map<String, dynamic> toJson() {
    return {'enable': enable, 'priority': priority, 'mandatory': mandatory};
  }
}

class MfaSettings {
  /// Define the settings for device share factor.
  final MfaSetting? deviceShareFactor;

  /// Define the settings for backup share factor.
  final MfaSetting? backUpShareFactor;

  /// Define the settings for social backup factor.
  final MfaSetting? socialBackupFactor;

  /// Define the settings for password factor.
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
  final ChainNamespace chainNamespace;
  final int? decimals;
  final String? blockExplorerUrl;
  final String chainId;
  final String? displayName;
  final String? logo;
  final String rpcTarget;
  final String? ticker;
  final String? tickerName;

  ChainConfig({
    this.chainNamespace = ChainNamespace.eip155,
    this.decimals = 18,
    this.blockExplorerUrl,
    required this.chainId,
    this.displayName,
    this.logo,
    required this.rpcTarget,
    this.ticker,
    this.tickerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'chainNamespace': chainNamespace.name,
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
  /// Client id for web3auth.
  ///
  /// You can obtain your client id from the web3auth [developer dashboard](https://dashboard.web3auth.io/).
  final String clientId;

  /// Web3Auth Network to use for the session & the issued idToken.
  ///
  /// User [Network.sapphire_mainnet] for production build.
  final Network network;

  /// [buildEnv] is used for internal testing purposes. This buildEnv
  /// signifies the enviroment for Web3Auth, and doesn't signifies
  /// the enviorment of the application.
  final BuildEnv? buildEnv;

  /// Define the desired Web3Auth service url.
  final String? sdkUrl;
  final String? walletSdkUrl;

  /// Deeplinking for the application where user will be redirected after login.
  /// Ideally, it should be bundleId and package name for iOS and Android respectively.
  ///
  /// While using redirectUrl, please make sure you have whitelisted it
  /// developer dashboard. Checkout [SDK reference](https://web3auth.io/docs/sdk/pnp/flutter/install#configuration-1) more details.
  final Uri redirectUrl;

  /// WhiteLabel options for web3auth. It helps you define
  /// custom UI, branding, and translations for your brand app.
  ///
  /// Checkout [WhiteLabelData] for more details.
  final WhiteLabelData? whiteLabel;

  /// Login config for the custom verifiers.
  final HashMap<String, LoginConfigItem>? loginConfig;

  /// Use [useCoreKitKey] to get the core kit key.
  final bool? useCoreKitKey;

  final ChainNamespace? chainNamespace;

  /// Allows developers to configure the [MfaSettings] for authentication.
  ///
  /// Checkout [MFA SDK Reference](https://web3auth.io/docs/sdk/pnp/flutter/mfa) for more details.
  final MfaSettings? mfaSettings;

  /// [sessionTime] allows developers to configure the session management time.
  ///
  /// Session Time is in seconds, default is 86400 seconds which is 1 day. [sessionTime] can be max 30 days.
  final int? sessionTime;

  final ChainConfig? chainConfig;

  final Map<String, String>? originData;

  final String? dashboardUrl;

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
    this.sessionTime = 30 * 86400,
    this.mfaSettings,
    this.originData,
    String? dashboardUrl,
  })  : chainConfig = null,
        sdkUrl = sdkUrl ?? getSdkUrl(buildEnv ?? BuildEnv.production),
        walletSdkUrl =
            walletSdkUrl ?? getWalletSdkUrl(buildEnv ?? BuildEnv.production),
        dashboardUrl =
            dashboardUrl ?? getDashboardUrl(buildEnv ?? BuildEnv.production);

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
      "chainConfig": chainConfig?.toJson(),
      "originData": originData,
      "dashboardUrl": dashboardUrl,
    };
  }
}

class UserCancelledException implements Exception {}

class UnKnownException implements Exception {
  final String? message;

  UnKnownException(this.message);
}

String getSdkUrl(BuildEnv? buildEnv) {
  const String version = "v9";
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
  const String walletServicesVersion = "v4";
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

String getDashboardUrl(BuildEnv? buildEnv) {
  const String walletAccountConstant = "wallet/account";
  switch (buildEnv) {
    case BuildEnv.staging:
      return "https://staging-account.web3auth.io/$walletAccountConstant";
    case BuildEnv.testing:
      return "https://develop-account.web3auth.io/$walletAccountConstant";
    case BuildEnv.production:
    default:
      return "https://account.web3auth.io/$walletAccountConstant";
  }
}
