import 'dart:async';

import 'package:flutter/services.dart';

class TrustLocation {
  static const MethodChannel _channel = const MethodChannel('trust_location');

  static Future<LatLongPosition> get getLatLong async {
    final String latitude = await _channel.invokeMethod('getLatitude');
    final String longitude = await _channel.invokeMethod('getLongitude');
    return LatLongPosition(latitude, longitude);
  }

  static Future<bool> get isMockLocation async {
    final bool isMock = await _channel.invokeMethod('isMockLocation');
    return isMock;
  }
}

class LatLongPosition {
  final String _latitude;
  final String _longitude;

  LatLongPosition([this._latitude, this._longitude])
      : assert(_latitude != null),
        assert(_longitude != null);

  String get longitude => _longitude;

  String get latitude => _latitude;

  @override
  String toString() {
    return 'Lat: $latitude, Long: $longitude';
  }
}
