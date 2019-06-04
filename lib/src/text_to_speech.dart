part of text_to_speech;

class FlutterTextToSpeech {
  FlutterTextToSpeech._();

  @visibleForTesting
  static const MethodChannel channel =
      const MethodChannel('flutter_text_to_speech');

  static final FlutterTextToSpeech instance = FlutterTextToSpeech._();

  VoiceController voiceController() {
    return VoiceController._();
  }
}
