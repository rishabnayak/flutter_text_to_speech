package com.flutter.text_to_speech;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterTextToSpeechPlugin */
public class FlutterTextToSpeechPlugin implements MethodCallHandler {

  private static Context context;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_text_to_speech");
    channel.setMethodCallHandler(new FlutterTextToSpeechPlugin());
    context = registrar.activeContext();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String text = call.argument("text");
    String languageCode = call.argument("languageCode");
    Map<String, Object> options = call.argument("options");
    switch (call.method){
      case "TextToSpeech#Init":
        FlutterTextToSpeech.instance.init(context, result);
        break;
      case "TextToSpeech#IsLangAvailable":
        FlutterTextToSpeech.instance.isLangAvailable(context, languageCode, result);
        break;
      case "TextToSpeech#GetAvailableLanguages":
        FlutterTextToSpeech.instance.getAvailableLanguages(context, result);
        break;
      case "TextToSpeech#SetLanguage":
        FlutterTextToSpeech.instance.setLanguage(context, languageCode, result);
        break;
      case "TextToSpeech#Speak":
        FlutterTextToSpeech.instance.speak(context, text, options, result);
        break;
      case "TextToSpeech#Stop":
        FlutterTextToSpeech.instance.stop(context, result);
        break;
      default:
        result.notImplemented();
    }
  }
}
