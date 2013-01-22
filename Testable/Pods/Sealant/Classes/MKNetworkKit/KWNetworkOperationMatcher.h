//
//  KWNetworkOperationMatcher.h
//
//  Created by Paul Zabelin on 5/24/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KWMatcher.h"
#import "KWMessageSpying.h"
#import "MKNetworkOperation.h"

typedef void (^NetworkRequestBlock)(NSURLRequest* request);
typedef void (^NetworkHttpMethodCallBlock)(NSString *method, NSURL *url, NSDictionary *parameters);

@interface KWNetworkOperationMatcher : KWMatcher <KWMessageSpying>

- (void)receiveOperation:(MKNKResponseBlock)block andRespond:(NSString *)responseString;
- (void)receiveRequest:(NetworkRequestBlock)block andRespond:(NSString *)responseString;
- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespond:(NSString *)responseString;
- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespondWithError:(NSError *)error;
- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespondEach:(NSArray *)aResponseArray;
- (void)receiveHttp:(NetworkHttpMethodCallBlock)block andRespondWithError:(NSError *)error andResponseString:(NSString *)responseString;
@end
