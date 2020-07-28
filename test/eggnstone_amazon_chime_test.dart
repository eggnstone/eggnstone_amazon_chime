import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';

void main() {
  const MethodChannel channel = MethodChannel('eggnstone_amazon_chime');

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
    expect(await EggnstoneAmazonChime.platformVersion, '42');
  });
}
