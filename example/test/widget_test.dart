import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trust_location/trust_location.dart';

void main() {
  const MethodChannel channel = MethodChannel('trust_location');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return false;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isMockLocation', () async {
    expect(await TrustLocation.isMockLocation, false);
  });
}
