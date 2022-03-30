import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('web3auth_flutter');

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
    expect(await Web3AuthFlutter.platformVersion, '42');
  });
}
