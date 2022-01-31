
import 'dart:async';

import 'package:flutter/services.dart';

class OpenloginFlutter {
  static const MethodChannel _channel = MethodChannel('openlogin_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
