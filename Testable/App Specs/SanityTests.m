//
//  TestableTests.m
//  TestableTests
//
//  Created by Blazing Pair on 1/15/13.
//  Copyright (c) 2013 Blazing Pair. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface SanityTests : SenTestCase
@end

@implementation SanityTests

- (void)testSenTestingKit {
    STAssertEquals(2, 1+1, @"SenTestingKit framework configured correctly and able to execute tests");
}

@end
