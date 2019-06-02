part of text_to_speech;

class VoiceController {
  VoiceController._(VoiceControllerOptions options)
      : _options = options,
        assert(options != null);

  final VoiceControllerOptions _options;

  Future<void> speak(String text) async {
    await FlutterTextToSpeech.channel
        .invokeMethod("TextToSpeech#Speak", <String, dynamic>{
      "options": <String, dynamic>{
        "androidLanguage": _options.androidLanguage,
        "iOSLanguage": _options.iOSLanguage,
        "speechRate": _options.speechRate,
        "pitch": _options.pitch,
        "volume": _options.volume,
      },
      "text": text
    });
  }

  Future<void> stop() async {
    await FlutterTextToSpeech.channel.invokeMethod("TextToSpeech#Stop");
  }
}

class VoiceControllerOptions {
  const VoiceControllerOptions(
      {this.androidLanguage = "",
      this.iOSLanguage = "",
      this.speechRate = 1,
      this.pitch = 1,
      this.volume = 1})
      : assert(speechRate >= 0.5),
        assert(speechRate <= 2),
        assert(pitch >= 0.5),
        assert(pitch <= 2),
        assert(volume >= 0),
        assert(volume <= 1);

  final String androidLanguage;
  final String iOSLanguage;
  final double speechRate;
  final double pitch;
  final double volume;
}
