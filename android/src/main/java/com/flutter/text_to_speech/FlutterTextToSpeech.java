package com.flutter.text_to_speech;

import android.content.Context;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

class FlutterTextToSpeech implements TTSAgent, TextToSpeech.OnInitListener {

    static final FlutterTextToSpeech instance = new FlutterTextToSpeech();

    private FlutterTextToSpeech() {
    }

    private TextToSpeech ttsAgent;
    private MethodChannel.Result initResult;
    private Bundle bundle = new Bundle();

    public void init(Context context, MethodChannel.Result result) {
        ttsAgent = new TextToSpeech(context, this);
        initResult = result;
    }

    @Override
    public void onInit(int i) {
        if (i == TextToSpeech.ERROR) {
            initResult.success(false);
        }
        initResult.success(true);
    }

    @Override
    public void isLangAvailable(Context context, String languageCode, MethodChannel.Result result) {
        if (ttsAgent.isLanguageAvailable(Locale.forLanguageTag(languageCode)) >= 0) {
            result.success(true);
        }
        result.success(false);
    }

    @Override
    public void getAvailableLanguages(Context context, MethodChannel.Result result) {
        Set<Locale> localeSet = ttsAgent.getAvailableLanguages();
        List<String> languages = new ArrayList<>(localeSet.size());
        for (Locale locale : localeSet) {
            languages.add(locale.toLanguageTag());
        }
        result.success(languages);
    }

    @Override
    public void setLanguage(Context context, String languageCode, MethodChannel.Result result) {
        if (ttsAgent.isLanguageAvailable(Locale.forLanguageTag(languageCode)) >= 0) {
            ttsAgent.setLanguage(Locale.forLanguageTag(languageCode));
            result.success(true);
        }
        result.error("Language Unavailable", null, false);
    }

    @Override
    public void speak(Context context, final String text, Map<String, Object> options, MethodChannel.Result result) {
        ttsAgent.setPitch(Float.parseFloat(options.get("pitch").toString()));
        ttsAgent.setSpeechRate(Float.parseFloat(options.get("speechRate").toString()));
        bundle.putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, Float.parseFloat(options.get("volume").toString()));
        if (options.get("delay").equals(new Integer(0))){
            ttsAgent.speak(text, TextToSpeech.QUEUE_FLUSH, bundle, UUID.randomUUID().toString());
        }
        long delay = Long.parseLong(options.get("delay").toString())*1000;
        ttsAgent.playSilentUtterance(delay, TextToSpeech.QUEUE_FLUSH, UUID.randomUUID().toString());
        ttsAgent.speak(text, TextToSpeech.QUEUE_ADD, bundle, UUID.randomUUID().toString());
        result.success(true);
    }

    @Override
    public void stop(Context context, MethodChannel.Result result) {
        ttsAgent.stop();
        ttsAgent.shutdown();
        ttsAgent = null;
        initResult = null;
        bundle.clear();
        result.success(true);
    }

}
