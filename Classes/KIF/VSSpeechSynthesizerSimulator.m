//
//  VSSpeechSynthesizerSimulator.m
//  Blazing Cloud
//
//  Created by Paul Zabelin on 8/10/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "VSSpeechSynthesizer.h"

#if TARGET_IPHONE_SIMULATOR

@implementation VSSpeechSynthesizer
+ (id)availableLanguageCodes {
    return nil;
}
+ (BOOL)isSystemSpeaking {
    return NO;
}

-(NSString *)selectVoiceForPhrase:(NSString *)phrase {
    NSDictionary *keywordToVoice = @{
    @"failures!" : @"Bad",
    @"failure!" : @"Bruce",
    @"FAIL" : @"Agnes"
    };
    NSString *keyword = nil;
    for (keyword in [keywordToVoice allKeys]) {
        BOOL found = NSNotFound != [phrase rangeOfString:keyword].location;
        if (found) {
            break;
        }
    }
    return keyword ? [keywordToVoice objectForKey:keyword] : @"Tessa ";
}

- (id)startSpeakingString:(id)what {
    NSString *voice = [self selectVoiceForPhrase:what];
    NSString *command = [NSString stringWithFormat:@"say -v %@ %@", voice, what];
    system([command cStringUsingEncoding:NSASCIIStringEncoding]);
    DLogObject(what);
    return nil;
}
- (id)startSpeakingString:(id)string toURL:(id)url {
    return nil;
}
- (id)startSpeakingString:(id)string toURL:(id)url withLanguageCode:(id)code {
    return nil;
}
- (float)rate {
    return 1;
}
- (id)setRate:(float)rate {
    return nil;
}
- (float)pitch {
    return 0.5;
}
- (id)setPitch:(float)pitch {
    return nil;
}
- (float)volume {
    return 0.8;
}
- (id)setVolume:(float)volume {
    return nil;
}
@end
#endif
