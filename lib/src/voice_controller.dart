part of text_to_speech;

class VoiceController {
  VoiceController._();

  bool _isInitialized = false;

  Future<bool> init() async {
    _isInitialized =
        await FlutterTextToSpeech.channel.invokeMethod("TextToSpeech#Init");
    return _isInitialized;
  }

  Future<bool> isLangAvailable(String languageCode) async {
    if (!_isInitialized) {
      throw new Exception(
          "isLangAvailable called on an uninitialized VoiceController");
    }
    final bool _isAvailable = await FlutterTextToSpeech.channel
        .invokeMethod("TextToSpeech#IsLangAvailable", <String, dynamic>{
      "languageCode": languageCode,
    });
    return _isAvailable;
  }

  Future<List<String>> getAvailableLanguages() async {
    if (!_isInitialized) {
      throw new Exception(
          "getAvailableLanguages called on an uninitialized VoiceController");
    }
    final List<String> languages = <String>[];
    final List<dynamic> _reply = await FlutterTextToSpeech.channel
        .invokeMethod("TextToSpeech#GetAvailableLanguages");
    for (dynamic lang in _reply) {
      languages.add(lang);
    }
    return languages;
  }

  Future<bool> setLanguage(String languageCode) async {
    if (!_isInitialized) {
      throw new Exception(
          "setlanguage called on an uninitialized VoiceController");
    }
    final bool _reply = await FlutterTextToSpeech.channel
        .invokeMethod("TextToSpeech#SetLanguage", <String, dynamic>{
      "languageCode": languageCode,
    });
    return _reply;
  }

  Future<void> speak(String text, [VoiceControllerOptions options]) async {
    if (!_isInitialized) {
      throw new Exception("Speak called on an uninitialized VoiceController");
    }
    await FlutterTextToSpeech.channel
        .invokeMethod("TextToSpeech#Speak", <String, dynamic>{
      "options": <String, dynamic>{
        "speechRate":
            options?.speechRate ?? VoiceControllerOptions().speechRate,
        "pitch": options?.pitch ?? VoiceControllerOptions().pitch,
        "volume": options?.volume ?? VoiceControllerOptions().volume,
      },
      "text": text
    });
  }

  Future<void> stop() async {
    if (!_isInitialized) {
      throw new Exception("Stop called on an uninitialized VoiceController");
    }
    await FlutterTextToSpeech.channel.invokeMethod("TextToSpeech#Stop");
    _isInitialized = false;
  }
}

class VoiceControllerOptions {
  const VoiceControllerOptions(
      {this.speechRate = 1, this.pitch = 1, this.volume = 1})
      : assert(speechRate >= 0.5),
        assert(speechRate <= 2),
        assert(pitch >= 0.5),
        assert(pitch <= 2),
        assert(volume >= 0),
        assert(volume <= 1);

  final double speechRate;
  final double pitch;
  final double volume;
}
