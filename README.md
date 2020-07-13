# Trust Location

A Flutter plugin for detecting mock location on Android device. (Supports only high accuracy location mode)
Please enable high accuracy in Android settings before using this plugin. [Read more](https://support.google.com/nexus/answer/3467281?hl=en)

## Installation

Add `trust_location` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Permissions

### Android

Add either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission to your Android Manifest. (located under android/app/src/main)

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

> **NOTE:** This plugin uses the AndroidX version of the Android Support Libraries. Detailed instructions can be found [here](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility).

## Usage

```dart
import 'package:trust_location/trust_location.dart';

/* Assuming in an async function */
/// query the current location.
LatLongPosition position = await TrustLocation.getLatLong;

/// check mock location on Android device.
bool isMockLocation = await TrustLocation.isMockLocation;
```

Using Stream.
```dart
// input seconds into parameter for getting location with repeating by timer.
// this example set to 5 seconds.
TrustLocation.start(5);

/// the stream getter where others can listen to.
TrustLocation.onChange.listen((values) =>
    print('${values.latitude} ${values.longitude} ${values.isMockLocation}')
);

/// stop repeating by timer
TrustLocation.stop();
```

## Example

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:trust_location/trust_location.dart';

import 'package:location_permissions/location_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _latitude;
  String _longitude;
  bool _isMockLocation;

  /// initialize state.
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    // input seconds into parameter for getting location with repeating by timer.
    // this example set to 5 seconds.
    TrustLocation.start(5);
    getLocation();
  }

  /// get location method, use a try/catch PlatformException.
  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((values) => setState(() {
            _latitude = values.latitude;
            _longitude = values.longitude;
            _isMockLocation = values.isMockLocation;
          }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  /// request location permission at runtime.
  void requestLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    print('permissions: $permission');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trust Location Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: <Widget>[
              Text('Mock Location: $_isMockLocation'),
              Text('Latitude: $_latitude, Longitude: $_longitude'),
            ],
          )),
        ),
      ),
    );
  }
}
```

## Credit

Detecting the mock location: [LocationAssistant](https://github.com/klaasnotfound/LocationAssistant)

## Issues

Please file any issues, bugs or feature request as an issue on our [issues](https://github.com/wongpiwat/flutter-trust-location/issues).

## Contribute

If you would like to contribute to the plugin, send us your [pull request](https://github.com/wongpiwat/flutter-trust-location/pulls).

## License

This plugin is open source project and the license is BSD.
