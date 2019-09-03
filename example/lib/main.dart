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
