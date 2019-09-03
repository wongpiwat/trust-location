# trust_location

A Flutter plugin for detecting the mock location of the Android device.

## Installation

Add `trust_location` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Usage

```dart
import 'package:trust_location/trust_location.dart';
...
String location = await TrustLocation.getLocation;
bool isMockLocation = await TrustLocation.isMockLocation;
...
```

## Credits

Detecting the mock location: [LocationAssistant](https://github.com/klaasnotfound/LocationAssistant)

Requesting location permission: [location_permissions](https://pub.dev/packages/location_permissions)

## License

This open source project, and the license is BSD.
