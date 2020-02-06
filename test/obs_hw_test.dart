import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obs_hw/obs_hw.dart';

void main() {
  const MethodChannel channel = MethodChannel('obs_hw');

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
    expect(await ObsHw.platformVersion, '42');
  });
}
