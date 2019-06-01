part of text_to_speech;

class FlutterTextToSpeech {
  static const MethodChannel _channel =
      const MethodChannel('flutter_text_to_speech');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
