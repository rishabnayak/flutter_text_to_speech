package com.flutter.text_to_speech;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

interface TTSAgent {

    void init(Context context, final MethodChannel.Result result);

    void isLangAvailable(Context context, String languageCode, final MethodChannel.Result result);

    void getAvailableLanguages(Context context, final MethodChannel.Result result);

    void setLanguage(Context context, String languageCode, final MethodChannel.Result result);

    void speak(
            Context context, String text, Map<String, Object> options, final MethodChannel.Result result);

    void stop(Context context, final MethodChannel.Result result);
}
