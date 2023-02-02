import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';

class Web3AuthFlutter {
  static const MethodChannel _channel = MethodChannel('web3auth_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> init(Web3AuthOptions initParams) async {
    Map<String, dynamic> initParamsJson = initParams.toJson();
    initParamsJson.removeWhere((key, value) => value == null);
    await _channel.invokeMethod('init', jsonEncode(initParamsJson));
  }

  static Future<Web3AuthResponse> login(LoginParams loginParams) async {
    try {
      Map<String, dynamic> loginParamsJson = loginParams.toJson();
      loginParamsJson.removeWhere((key, value) => value == null);
      final String loginResponse = await _channel.invokeMethod(
        'login',
        jsonEncode(loginParamsJson),
      );
      return Web3AuthResponse.fromJson(jsonDecode(loginResponse));
    } on PlatformException catch (e) {
      switch (e.code) {
        case "UserCancelledException":
          throw UserCancelledException();
        case "NoAllowedBrowserFoundException":
          throw UnKnownException(e.message);
        default:
          rethrow;
      }
    }
  }

  static Future<void> logout() async {
    try {
      await _channel.invokeMethod('logout', jsonEncode({}));
      return;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "UserCancelledException":
          throw UserCancelledException();
        case "NoAllowedBrowserFoundException":
          throw UnKnownException(e.message);
        default:
          rethrow;
      }
    }
  }

  static Future<Web3AuthResponse> sessionResponse() async {
    try {
      final String loginResponse = await _channel.invokeMethod(
        'sessionResponse',
        jsonEncode({}),
      );
      return Web3AuthResponse.fromJson(jsonDecode(loginResponse));
    } on PlatformException catch (e) {
      switch (e.code) {
        case "UserCancelledException":
          throw UserCancelledException();
        case "NoAllowedBrowserFoundException":
          throw UnKnownException(e.message);
        default:
          rethrow;
      }
    }
  }
}
