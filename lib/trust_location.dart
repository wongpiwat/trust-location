import 'dart:async';

import 'package:flutter/services.dart';

class TrustLocation {
  static const MethodChannel _channel = const MethodChannel('trust_location');
  static var changeController =
      new StreamController<LatLongPosition>.broadcast();
  static Timer? getLocationTimer;

  /// start get location with repeating by timer
  static start(time) {
    getLocationTimer =
        Timer.periodic(Duration(seconds: time), (Timer t) => getLocation());
  }

  /// stop repeating by timer
  static stop() {
    getLocationTimer?.cancel();
  }

  /// get location and mock
  static Future<void> getLocation() async {
    List<String?> position;
    bool isMockLocation;
    try {
      position = await TrustLocation.getLatLong;
      isMockLocation = await TrustLocation.isMockLocation;
      changeController
          .add(new LatLongPosition(position[0], position[1], isMockLocation));
    } on PlatformException catch (e) {
      print('PlatformException: $e');
    }
  }

  /// the stream getter where others can listen to.
  static Stream<LatLongPosition> get onChange => changeController.stream;

  /// query the current location.
  static Future<List<String?>> get getLatLong async {
    final String? latitude = await _channel.invokeMethod('getLatitude');
    final String? longitude = await _channel.invokeMethod('getLongitude');
    return [latitude, longitude];
  }

  /// check mock location on Android device.
  static Future<bool> get isMockLocation async {
    final bool isMock = await _channel.invokeMethod('isMockLocation');
    return isMock;
  }

  void dispose() {
    changeController.close();
  }
}

class LatLongPosition {
  final String? _latitude;
  final String? _longitude;
  final bool? _isMock;

  LatLongPosition([this._latitude, this._longitude, this._isMock]);

  /// get latitude.
  String? get latitude => _latitude;

  /// get longitude.
  String? get longitude => _longitude;

  /// is mock location.
  bool? get isMockLocation => _isMock;

  /// return the string of latitude and longitude.
  @override
  String toString() {
    return 'Lat: $_latitude, Long: $_longitude, Mock: $_isMock';
  }
}
