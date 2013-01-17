//
//  BZSpecHelper.h
//
//  Created by Blazing Pair on 6/4/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

extern const NSUInteger kNetworkTimeout;

#define shouldEventuallyBeTrue(x) [[expectFutureValue(@(x)) shouldEventuallyBeforeTimingOutAfter(kNetworkTimeout)] beTrue]

@interface BZSpecHelper : NSObject
+ (BOOL)isHeadlessUser;
+ (void)ensureDirectoryExists:(NSSearchPathDirectory)directory;
+ (NSURL *)urlForTestFile:(NSString *)aFileName;
+ (NSData *)testDataFromFile:(NSString *)aFileName;
@end

