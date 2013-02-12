//
//  BZMockInjector.m
//
//  Created by Paul Zabelin on 11/29/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "BZMockInjector.h"
#import <Objection.h>
#import <Kiwi.h>

@implementation BZMockInjector

+ (id)mockBoundToClass:(Class)aClass {
    JSObjectionModule *module = [[JSObjectionModule alloc] init];
    id mock = [KWMock mockForClass:aClass];
    [module bind:mock toClass:aClass];
    JSObjectionInjector *injector = [JSObjection createInjector:module];
    [JSObjection setDefaultInjector:injector];
    NSParameterAssert(mock == [injector getObject:aClass]);
    return mock;
}

+ (id)mockBoundToProtocol:(Protocol*)aProtocol {
    JSObjectionModule *module = [[JSObjectionModule alloc] init];
    id mock = [KWMock mockForProtocol:aProtocol];
    [module bind:mock toProtocol:aProtocol];
    JSObjectionInjector *injector = [JSObjection createInjector:module];
    [JSObjection setDefaultInjector:injector];
    NSParameterAssert(mock == [injector getObject:aProtocol]);
    return mock;
}

@end

