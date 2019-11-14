import 'dart:async';

import 'package:flutter/services.dart';

class TrustLocation {
  static const MethodChannel _channel = const MethodChannel('trust_location');

  /// get latitude and longitude.
  static Future<LatLongPosition> get getLatLong async {
    final String latitude = await _channel.invokeMethod('getLatitude');
    final String longitude = await _channel.invokeMethod('getLongitude');
    return LatLongPosition(latitude, longitude);
  }

  /// check mock location on an Android device.
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

  /// get latitude.
  String get latitude => _latitude;

  /// get longitude.
  String get longitude => _longitude;

  /// return the string of latitude and longitude.
  @override
  String toString() {
    return 'Lat: $latitude, Long: $longitude';
  }
}
