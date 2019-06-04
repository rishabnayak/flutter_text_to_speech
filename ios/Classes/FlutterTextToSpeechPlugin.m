#import "FlutterTextToSpeechPlugin.h"

@import AVFoundation;

@implementation FlutterTextToSpeechPlugin

AVSpeechSynthesizer *synth;
AVSpeechSynthesisVoice *selectedVoice;
AVSpeechUtterance *utterance;
NSArray<AVSpeechSynthesisVoice *> *voices;
NSMutableArray<NSString *> *languageSet;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_text_to_speech"
            binaryMessenger:[registrar messenger]];
  FlutterTextToSpeechPlugin* instance = [[FlutterTextToSpeechPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *text = call.arguments[@"text"];
    NSString *languageCode = call.arguments[@"languageCode"];
    NSDictionary *options = call.arguments[@"options"];
  if ([@"TextToSpeech#Init" isEqualToString:call.method]){
      [FlutterTextToSpeechPlugin init: result];
  } else if ([@"TextToSpeech#IsLangAvailable" isEqualToString:call.method]){
      [FlutterTextToSpeechPlugin isLangAvailable: languageCode result:result];
  } else if ([@"TextToSpeech#GetAvailableLanguages" isEqualToString:call.method]){
      [FlutterTextToSpeechPlugin getAvailableLanguages: result];
  } else if ([@"TextToSpeech#SetLanguage" isEqualToString:call.method]){
      [FlutterTextToSpeechPlugin setLanguage: languageCode result: result];
  } else if ([@"TextToSpeech#Speak" isEqualToString:call.method]){
      [FlutterTextToSpeechPlugin speak: text options: options result: result];
  } else if ([@"TextToSpeech#Stop" isEqualToString:call.method]){
      [FlutterTextToSpeechPlugin stop: result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

+ (void)init:(FlutterResult)result{
    synth = [AVSpeechSynthesizer alloc];
    voices = AVSpeechSynthesisVoice.speechVoices;
    languageSet = [NSMutableArray new];
    for (AVSpeechSynthesisVoice *voice in voices){
        NSString *lang = [voice language];
        [languageSet addObject:lang];
    }
    result(@(YES));
}

+ (void)isLangAvailable:(NSString *)languageCode result:(FlutterResult)result{
    if([languageSet containsObject:languageCode]){
        result(@(YES));
    }
    result(@(NO));
}

+ (void)getAvailableLanguages:(FlutterResult)result{
    result(languageSet);
}

+ (void)setLanguage:(NSString *)languageCode result:(FlutterResult)result{
    if([languageSet containsObject:languageCode]){
        selectedVoice = [AVSpeechSynthesisVoice voiceWithLanguage:languageCode];
        result(@(YES));
    }
    result(@(NO));
}

+ (void)speak:(NSString *)text options:(NSDictionary *)options result:(FlutterResult)result{
    utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.pitchMultiplier = [options[@"pitch"] floatValue];
    if ([options[@"speechRate"] floatValue] == 1){
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    } else {
        utterance.rate = [options[@"speechRate"] floatValue];
    }
    utterance.volume = [options[@"volume"] floatValue];
    utterance.voice = selectedVoice;
    [synth speakUtterance:utterance];
}

+ (void)stop:(FlutterResult)result{
    [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

@end
