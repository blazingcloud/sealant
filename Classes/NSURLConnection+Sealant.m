//
//  NSURLConnection+UnitSpecs.m
//
//  Created by Blazing Pair on 11/7/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import <JRSwizzle.h>
#import "BZSpecHelper.h"

NSString* const NETWORK_DISABLED_WHILE_TESTING = @"attempt to create network connection from unit tests";

@implementation NSURLConnection (Sealant)

+ (NSURLConnection*)doNotAlloc {
    [NSException raise:NETWORK_DISABLED_WHILE_TESTING format:nil];
    return nil;
}

+ (NSURLConnection*)noConnectionWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    [NSException raise:NETWORK_DISABLED_WHILE_TESTING
                format:@"request: %@, delegate: %@", request, delegate];
    return nil;
}

+ (BOOL)canNotHandleRequest:(NSURLRequest *)request {
    return NO;
}

+ (void)initialize {
    if ([BZSpecHelper executingUnitTestsNotApplicationTests]) {
        NSError *error = nil;
        BOOL swizzled = [NSURLConnection jr_swizzleClassMethod:@selector(alloc)
                                               withClassMethod:@selector(doNotAlloc)
                                                         error:&error];
        NSAssert1(!error && swizzled, @"Failed to disable network operation start method for unit specs, due to: %@", error);
        swizzled = [NSURLConnection jr_swizzleClassMethod:@selector(connectionWithRequest:delegate:)
                                          withClassMethod:@selector(noConnectionWithRequest:delegate:)
                                                    error:&error];
        NSAssert1(!error && swizzled, @"Failed to disable network operation start method for unit specs, due to: %@", error);
        swizzled = [NSURLConnection jr_swizzleClassMethod:@selector(canHandleRequest:)
                                          withClassMethod:@selector(canNotHandleRequest:)
                                                    error:&error];
        NSAssert1(!error && swizzled, @"Failed to disable network operation start method for unit specs, due to: %@", error);
    }
}

@end
