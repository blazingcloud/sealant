//
//  MKNetworkOperation+Sealant.m
//
//  Created by Blazing Pair on 11/7/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import <MKNetworkKit.h>
#import <JRSwizzle.h>
#import "BZSpecHelper.h"

@implementation MKNetworkOperation (Sealant)
- (void) doNotStart {
    [NSException raise:@"attempt to start network operation from unit tests" format:nil];
}

+ (void)initialize {
    if ([BZSpecHelper executingUnitTestsNotApplicationTests]) {
        NSError *error = nil;
        BOOL swizzled = [MKNetworkOperation jr_swizzleMethod:@selector(start)
                                                  withMethod:@selector(doNotStart)
                                                       error:&error];
        NSAssert1(!error && swizzled, @"Failed to disable network operation start method for unit specs, due to: %@", error);
    }
}
@end
