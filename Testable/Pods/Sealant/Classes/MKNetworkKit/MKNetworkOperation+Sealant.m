//
//  MKNetworkOperation+Sealant.m
//
//  Created by Blazing Pair on 11/7/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import <MKNetworkKit.h>
#import <JRSwizzle.h>

@implementation MKNetworkOperation (Sealant)
- (void) doNotStart {
    [NSException raise:@"attempt to start network operation from unit tests" format:nil];
}

+ (void)initialize {
    NSError *error = nil;
    [MKNetworkOperation jr_swizzleMethod:@selector(start)
                              withMethod:@selector(doNotStart)
                                   error:&error];
    NSAssert1(!error, @"Failed to disable network operation start method for unit specs, due to: %@", error);
}
@end
