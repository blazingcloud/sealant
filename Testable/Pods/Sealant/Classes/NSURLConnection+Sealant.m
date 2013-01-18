//
//  NSURLConnection+UnitSpecs.m
//
//  Created by Blazing Pair on 11/7/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

NSString* const NETWORK_DISABLED_WHILE_TESTING = @"attempt to create network connection from unit tests";

@implementation NSURLConnection (Sealant)

+ (NSURLConnection*)alloc {
    [NSException raise:NETWORK_DISABLED_WHILE_TESTING format:nil];
    return nil;
}

+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    [NSException raise:NETWORK_DISABLED_WHILE_TESTING
                format:@"request: %@, delegate: %@", request, delegate];
    return nil;
}

+ (BOOL)canHandleRequest:(NSURLRequest *)request {
    return NO;
}
@end

#pragma clang diagnostic pop

