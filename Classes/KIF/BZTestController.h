//
//  BZTestController.h
//  Blazing Cloud
//
//  Created by Blazing Pair on 7/2/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KIFTestController.h"

@interface BZTestController : KIFTestController <UIAlertViewDelegate>
- (void)startTesting;
- (void)say:(NSString *)what;
- (void)sayStepFailed;
@end
