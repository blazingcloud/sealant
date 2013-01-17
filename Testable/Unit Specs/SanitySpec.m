//
//  SanitySpec.m
//  SanitySpec
//
//  Created by Blazing Pair on 1/15/13.
//  Copyright (c) 2013 Blazing Pair. All rights reserved.
//

#import <Kiwi.h>

SPEC_BEGIN(SanitySpec)

describe(@"Kiwi", ^{
  it(@"is pretty cool", ^{
    NSUInteger a = 16;
    NSUInteger b = 26;
    [[@(a + b) should] equal:@42];
  });
});

SPEC_END