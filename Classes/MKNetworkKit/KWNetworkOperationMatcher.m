//
//  KWNetworkOperationMatcher.m
//
//  Created by Paul Zabelin on 5/24/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KWNetworkOperationMatcher.h"
#import "KWFormatter.h"
#import "KWMessagePattern.h"
#import "NSObject+KiwiStubAdditions.h"
#import "MKNetworkEngine.h"
#import "BZSpecHelper.h"

@interface MKNetworkOperation (Test)
@property (nonatomic, strong) NSData *cachedResponse;
@end

@interface KWNetworkOperationMatcher()

#pragma mark - Properties

@property (nonatomic, readwrite, copy) MKNKResponseBlock processOperationBlock;
@property (nonatomic, readwrite, copy) NetworkRequestBlock processUrlRequestBlock;
@property (nonatomic, readwrite, copy) NetworkHttpMethodCallBlock processHttpMethodCallBlock;
@property (nonatomic, readwrite, retain) MKNetworkOperation *request;
@property (nonatomic, readwrite, retain) id response;
@property (nonatomic, readwrite, retain) NSString *errorResponse;
@property (nonatomic, assign) BOOL requestHasBeenProcessed;

@end

@implementation KWNetworkOperationMatcher {
@private
    NSUInteger responseIndex;
}


#pragma mark - Private

typedef enum {
    kKWNetworkOperationErrorResponse,
    kKWNetworkOperationSuccessStringResponse,
    kKWNetworkOperationSuccessArrayOfStringResponses,
    kKWNetworkOperationInvalidResponse = NSNotFound,
} responseType;

- (void)processSuccessfulResponse:(NSString *)responseString {
    NSData *cachedData = nil;
    if ([responseString hasSuffix:@".xml"] || [responseString hasSuffix:@".png"]|| [responseString hasSuffix:@".json"]) {
        cachedData = [SpecHelper testDataFromFile:responseString];
    } else {
        cachedData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    }
    [self.request setCachedData:cachedData];
}

- (responseType)responseType {
    static NSArray *responseTypes = nil;
    if (!responseTypes) {
        responseTypes = @[[NSError class], [NSString class], [NSArray class]];
    }
    for (Class errorClass in responseTypes) {
        if ([[self.response class] isSubclassOfClass:errorClass]) {
            return [responseTypes indexOfObject:errorClass];
        }
    }
    return kKWNetworkOperationInvalidResponse;
}

- (void)processErrorResponse {
    if (self.errorResponse) {
        self.request.cachedResponse = [self.errorResponse dataUsingEncoding:NSUTF8StringEncoding];
    }
    [self.request operationFailedWithError:self.response];
}

- (void)respond {
    switch ([self responseType]) {
        case kKWNetworkOperationErrorResponse:
            [self processErrorResponse];
            break;
        case kKWNetworkOperationSuccessStringResponse:
            [self processSuccessfulResponse:self.response];
            break;
        case kKWNetworkOperationSuccessArrayOfStringResponses:
            [self processSuccessfulResponse:[self.response objectAtIndex:responseIndex]];
            responseIndex++;
            break;
        case kKWNetworkOperationInvalidResponse:
        default:
            [NSException raise:@"Invalid response to mock" format:@"response:%@", self.response];
            break;
    }
}

- (NSDictionary *)requestParameters {
    NSURLRequest *urlRequest = [self.request readonlyRequest];
    NSString *method = [urlRequest HTTPMethod];
    if ([@"POST" isEqualToString:method]) {
        return [self.request readonlyPostDictionary];
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *query = [[urlRequest URL] query];
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs) {
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = nil;
            if ([elements count] > 0) {
                value = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            } else {
                value = @"";
            }
            [parameters setObject:value forKey:key];
        }
        return parameters;
    }
}

- (void)validateRequest {
}

- (void)processRequest {
    if (self.processOperationBlock) {
        self.processOperationBlock(self.request);
    } else if (self.processUrlRequestBlock) {
        self.processUrlRequestBlock([self.request readonlyRequest]);
    } else if (self.processHttpMethodCallBlock) {
        NSURLRequest *urlRequest = [self.request readonlyRequest];
        self.processHttpMethodCallBlock([urlRequest HTTPMethod], [urlRequest URL], [self requestParameters]);
    } else {
        NSAssert(false, @"one of the process block should be set");
    }
}

- (void)addSpy {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(enqueueOperation:)];
    [self.subject addMessageSpy:self forMessagePattern:messagePattern];
    [self.subject stubMessagePattern:messagePattern andReturn:nil];
}

- (void)addSpyForResponse:(NSObject *)responseObject {
    [self addSpy];
    self.response = responseObject;
}

- (void)prepare:(NetworkHttpMethodCallBlock)block andRespond:(NSObject *)responseObject {
    self.processHttpMethodCallBlock = block;
    [self addSpyForResponse:responseObject];
}

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[
    @"receiveOperation:andRespond:",
    @"receiveRequest:andRespond:",
    @"receiveHttp:andRespond:",
    @"receiveHttp:andRespondWithError:",
    @"receiveHttp:andRespondEach:",
    @"receiveHttp:andRespondWithError:andResponseString:"
    ];
}

#pragma mark - Matching

- (BOOL)evaluate {
    return self.requestHasBeenProcessed;
}

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

#pragma mark - Getting Matcher Compatability

+ (BOOL)canMatchSubject:(id)anObject {
    return [anObject isKindOfClass:[MKNetworkEngine class]];
}

#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected %@ to receive request and respond with %@",
            [KWFormatter formatObject:self.subject],
            self.response
            ];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected %@ not to receive request",
            [KWFormatter formatObject:self.subject]
            ];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"receive request and respond with %@",
            self.response
            ];
}

#pragma mark - Configuring Matchers

- (void)receiveOperation:(MKNKResponseBlock)block andRespond:(NSString *)responseString {
    self.processOperationBlock = block;
    [self addSpyForResponse:responseString];
}

- (void)receiveRequest:(NetworkRequestBlock)block andRespond:(NSString *)responseString {
    self.processUrlRequestBlock = block;
    [self addSpyForResponse:responseString];
}

- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespond:(NSString *)responseString {
    [self prepare:block andRespond:responseString];
}

- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespondWithError:(NSError *)error {
    [self prepare:block andRespond:error];
}

- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespondWithError:(NSError *)error andResponseString:(NSString *)responseString {
    [self prepare:block andRespond:error];
    self.errorResponse = responseString;
}

- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespondEach:(NSArray *)reponses {
    [self prepare:block andRespond:reponses];
}

#pragma mark - KWMessageSpying

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    [anInvocation getArgument:&_request atIndex:2];
    [self validateRequest];
    [self processRequest];
    [self respond];
    self.requestHasBeenProcessed = YES;
}

@end
