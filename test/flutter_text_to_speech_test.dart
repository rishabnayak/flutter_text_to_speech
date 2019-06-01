import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_text_to_speech');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterTextToSpeech.platformVersion, '42');
  });
}
