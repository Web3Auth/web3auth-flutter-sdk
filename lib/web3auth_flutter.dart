import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';

class Web3AuthFlutter {
  static const MethodChannel _channel = MethodChannel('web3auth_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static bool _isLoginSuccessful = false;

  static Future<void> init(Web3AuthOptions initParams) async {
    Map<String, dynamic> initParamsJson = initParams.toJson();
    initParamsJson.removeWhere((key, value) => value == null);
    await _channel.invokeMethod('init', jsonEncode(initParamsJson));
  }

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

  static Future<void> logout() async {
    try {
      await _channel.invokeMethod('logout', jsonEncode({}));
      return;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  static Future<void> initialize() async {
    try {
      await _channel.invokeMethod('initialize', jsonEncode({}));
      return;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  static Future<String> getPrivKey() async {
    try {
      final String privKey =
          await _channel.invokeMethod('getPrivKey', jsonEncode({}));
      return privKey;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  static Future<String> getEd25519PrivKey() async {
    try {
      final String getEd25519PrivKey =
          await _channel.invokeMethod('getEd25519PrivKey', jsonEncode({}));
      return getEd25519PrivKey;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  static Future<TorusUserInfo> getUserInfo() async {
    try {
      final String torusUserInfo =
          await _channel.invokeMethod('getUserInfo', jsonEncode({}));
      return TorusUserInfo.fromJson(jsonDecode(torusUserInfo));
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

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
