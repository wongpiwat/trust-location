import 'dart:async';

import 'package:flutter/services.dart';

class TrustLocation {
  static const MethodChannel _channel = const MethodChannel('trust_location');

  static Future<String> get getLocation async {
    final String location = await _channel.invokeMethod('getLocation');
    return location;
  }

  static Future<bool> get isMockLocation async {
    final bool isMock = await _channel.invokeMethod('isMockLocation');
    return isMock;
  }
}
