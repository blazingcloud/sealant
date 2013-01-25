//
//  BZSpecHelper.m
//
//  Created by Blazing Pair on 6/4/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "BZSpecHelper.h"

const NSUInteger kNetworkTimeout = 30;

@implementation BZSpecHelper

+ (void)ensureDirectoryExists:(NSSearchPathDirectory)directory {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager createDirectoryAtPath:docDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
    NSParameterAssert(!error);
}

+ (BOOL)hasMainBundle {
    return [[[NSBundle mainBundle] bundlePath] hasSuffix:@".app"];
}

+ (BOOL)executingUnitTestsNotApplicationTests {
    return ![self hasMainBundle];
}

+ (BOOL)isHeadlessUser {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    return !![environment objectForKey:@"LOGNAME"];
}

+ (NSURL *)urlForTestFile:(NSString *)aFileName {
    return [[[NSBundle bundleForClass:[self class]] bundleURL]
            URLByAppendingPathComponent:aFileName];
}

+ (NSData *)testDataFromFile:(NSString *)aFileName {
    NSURL *resourceUrl = [self urlForTestFile:aFileName];
    NSParameterAssert(resourceUrl);
    return [NSData dataWithContentsOfURL:resourceUrl];
}

@end
