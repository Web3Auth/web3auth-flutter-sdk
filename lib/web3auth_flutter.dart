import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';

class Web3AuthFlutter {
  static const MethodChannel _channel = MethodChannel('web3auth_flutter');

  static bool _isLoginSuccessful = false;
  
  /// [init] methods helps you setup [Web3AuthFlutter] SDK. You can add 
  /// whitelabeling, redirect url, and set other parameters during init.
  /// 
  /// Please checkout [Web3AuthOptions] for more details
  static Future<void> init(Web3AuthOptions initParams) async {
    Map<String, dynamic> initParamsJson = initParams.toJson();
    initParamsJson.removeWhere((key, value) => value == null);
    await _channel.invokeMethod('init', jsonEncode(initParamsJson));
  }
  
  /// [login] method will initiate login flow, opening the browser allowing
  /// users to authenticate themselves with preferred login provider.
  /// 
  /// Use [loginParams] to change the login provider, curve, and other parameters.
  /// For more details, look into [LoginParams].
  static Future<Web3AuthResponse> login(LoginParams loginParams) async {
    try {
      _isLoginSuccessful = false;
      Map<String, dynamic> loginParamsJson = loginParams.toJson();
      loginParamsJson.removeWhere((key, value) => value == null);
      final String loginResponse = await _channel.invokeMethod(
        'login',
        jsonEncode(loginParamsJson),
      );
      _isLoginSuccessful = true;
      return Web3AuthResponse.fromJson(jsonDecode(loginResponse));
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }
  
  /// [logout] method will initiate the logout for current session.
  static Future<void> logout() async {
    try {
      await _channel.invokeMethod('logout', jsonEncode({}));
      return;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }
  
  /// Initializes the [Web3AuthFlutter], please make sure you have
  /// called initialize before performing any other operation. 
  static Future<void> initialize() async {
    try {
      await _channel.invokeMethod('initialize', jsonEncode({}));
      return;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }
  
  /// Returns the secp256k1 EVM compaitible key if the user is successfully 
  /// authenticated.
  ///
  /// If user is not authenticated, it'll return empty string.
  static Future<String> getPrivKey() async {
    try {
      final String privKey =
          await _channel.invokeMethod('getPrivKey', jsonEncode({}));
      return privKey;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }
  
  /// Returns the ed25519 Solana compaitible key if the user is successfully 
  /// authenticated.
  ///
  /// If user is not authenticated, it'll return empty string.
  static Future<String> getEd25519PrivKey() async {
    try {
      final String getEd25519PrivKey =
          await _channel.invokeMethod('getEd25519PrivKey', jsonEncode({}));
      return getEd25519PrivKey;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }
  
  /// Returns the user information such as email address, name, session id, and etc.
  /// 
  /// If user is not authenticated, it'll throw an error.
  static Future<TorusUserInfo> getUserInfo() async {
    try {
      final String torusUserInfo =
          await _channel.invokeMethod('getUserInfo', jsonEncode({}));
      return TorusUserInfo.fromJson(jsonDecode(torusUserInfo));
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }
  
  /// [setResultUrl] helps to trigger the [UserCancelledException] exception
  /// on Android. 
  /// 
  /// The Android SDK uses the custom tabs and from current implementation of chrome custom tab, 
  /// it's not possible to add a listener directly to chrome custom tab close button and 
  /// trigger login exceptions.
  /// 
  /// If you want to trigger exception for user closing the browser tab, you have to use 
  /// WidgetsBindingObserver mixin with your your login screen.
  /// 
  /// Please checkout [Flutter SDK reference](https://web3auth.io/docs/sdk/pnp/flutter/usage#setresulturl) to know more.
  static Future<void> setResultUrl() async {
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      if (Platform.isAndroid && !_isLoginSuccessful) {
        await _channel.invokeMethod('setResultUrl');
      }
      return;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  static Exception _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case "UserCancelledException":
        return UserCancelledException();
      case "NoAllowedBrowserFoundException":
        return UnKnownException(e.message);
      default:
        return e;
    }
  }
}
