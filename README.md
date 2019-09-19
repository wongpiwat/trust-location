# Trust Location

A Flutter plugin for detecting the mock location of the Android device.

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
...
LatLongPosition position = await TrustLocation.getLatLong;
bool isMockLocation = await TrustLocation.isMockLocation;
...
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _latitude;
  String _longitude;
  bool _isMockLocation = false;
  Timer getLocationCallback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLocationPermission();
    executeGetLocationCallback();
  }

  void executeGetLocationCallback() {
    getLocationCallback =
        Timer.periodic(Duration(seconds: 5), (Timer t) => _getLocation());
  }

  Future<void> _getLocation() async {
    LatLongPosition position;
    bool isMockLocation;
    try {
      position = await TrustLocation.getLatLong;
      isMockLocation = await TrustLocation.isMockLocation;
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _isMockLocation = isMockLocation;
    });
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

  void getLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    print('permissions: $permission');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      executeGetLocationCallback();
    }
    if (state == AppLifecycleState.inactive) {
      getLocationCallback.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
```

## Credits

Detecting the mock location: [LocationAssistant](https://github.com/klaasnotfound/LocationAssistant)

Requesting location permission: [location_permissions](https://pub.dev/packages/location_permissions)

## Issues

Please file any issues, bugs or feature request as an issue on our [issues](https://github.com/wongpiwat/flutter-trust-location/issues).

## Contribute

If you would like to contribute to the plugin, send us your [pull request](https://github.com/wongpiwat/flutter-trust-location/pulls).

## License

This plugin is open source project and the license is BSD.
