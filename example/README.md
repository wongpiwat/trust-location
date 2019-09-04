# trust_location_example

Demonstrates how to use the trust_location plugin.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


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
  String _location = "None";
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
    String location;
    bool isMockLocation;
    try {
      location = await TrustLocation.getLocation;
      isMockLocation = await TrustLocation.isMockLocation;
    } on PlatformException catch(e) {
      print('PlatformException $e');
    }
    setState(() {
      _location = location;
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
              Text('$_location'),
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
