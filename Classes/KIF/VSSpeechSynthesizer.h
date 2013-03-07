//
//  VSSpeechSynthesizer.h
//  Blazing Cloud
//
//  Created by Paul Zabelin on 8/9/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

@interface VSSpeechSynthesizer : NSObject {}
+ (id)availableLanguageCodes;
+ (BOOL)isSystemSpeaking;
- (id)startSpeakingString:(id)string;
- (id)startSpeakingString:(id)string toURL:(id)url;
- (id)startSpeakingString:(id)string toURL:(id)url withLanguageCode:(id)code;
- (float)rate;              // default rate: 1
- (id)setRate:(float)rate;
- (float)pitch;             // default pitch: 0.5
- (id)setPitch:(float)pitch;
- (float)volume;            // default volume: 0.8
- (id)setVolume:(float)volume;
@end