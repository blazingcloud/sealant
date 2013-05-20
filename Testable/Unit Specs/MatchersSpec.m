//
//  SanitySpec.m
//  SanitySpec
//
//  Created by Blazing Pair on 1/15/13.
//  Copyright (c) 2013 Blazing Pair. All rights reserved.
//

#import <Kiwi.h>
#import <OCHamcrest.h>

#ifndef HC_SHORTHAND
#error Hamcrest shorthand macros are not enabled, please add HC_SHORTHAND to the target
#endif

SPEC_BEGIN(HamcrestMatchersSpec)

describe(@"Hamcrest", ^{
  it(@"is pretty cool", ^{
    NSUInteger a = 16;
    NSUInteger b = 26;
    [[@(a + b) should] match:equalTo(@42)];
  });
});

SPEC_END
