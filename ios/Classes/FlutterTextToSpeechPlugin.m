#import "FlutterTextToSpeechPlugin.h"

@import AVFoundation;

@implementation FlutterTextToSpeechPlugin

AVSpeechSynthesizer *synth;
AVSpeechSynthesisVoice *selectedVoice;
AVSpeechUtterance *utterance;
NSArray<AVSpeechSynthesisVoice *> *voices;
NSMutableArray<NSString *> *ttsLanguageSet;

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
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:(AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker) error:&error];
    synth = [AVSpeechSynthesizer alloc];
    voices = AVSpeechSynthesisVoice.speechVoices;
    ttsLanguageSet = [NSMutableArray new];
    for (AVSpeechSynthesisVoice *voice in voices){
        NSString *lang = [voice language];
        [ttsLanguageSet addObject:lang];
    }
    result(@(YES));
}

+ (void)isLangAvailable:(NSString *)languageCode result:(FlutterResult)result{
    if([ttsLanguageSet containsObject:languageCode]){
        result(@(YES));
    }
    result(@(NO));
}

+ (void)getAvailableLanguages:(FlutterResult)result{
    result(ttsLanguageSet);
}

+ (void)setLanguage:(NSString *)languageCode result:(FlutterResult)result{
    if([ttsLanguageSet containsObject:languageCode]){
        selectedVoice = [AVSpeechSynthesisVoice voiceWithLanguage:languageCode];
        result(@(YES));
    }
    result(@(NO));
}

+ (void)speak:(NSString *)text options:(NSDictionary *)options result:(FlutterResult)result{
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.preUtteranceDelay = [options[@"delay"] floatValue];
    utterance.pitchMultiplier = [options[@"pitch"] floatValue];
    if ([options[@"speechRate"] floatValue] == 1){
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    } else {
        utterance.rate = [options[@"speechRate"] floatValue];
    }
    utterance.volume = [options[@"volume"] floatValue];
    utterance.voice = selectedVoice;
    [synth speakUtterance:utterance];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    result(@(YES));
}

+ (void)stop:(FlutterResult)result{
    [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    result(@(YES));
}

@end
