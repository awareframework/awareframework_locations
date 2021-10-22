import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:awareframework_locations/awareframework_locations.dart';

void main() {
  const MethodChannel channel = MethodChannel('awareframework_locations');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AwareframeworkLocations.platformVersion, '42');
  });
}
