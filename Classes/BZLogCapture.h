//
//  BZLogCapture.h
//
//  Created by Paul Zabelin on 2/8/12.
//  Copyright (c) 2012 Blazing Cloud. All rights reserved.
//

@interface BZLogCapture : NSObject
@property (nonatomic, assign) BOOL redirected;
- (NSString *)end;
@end

@interface BZQueuetLogCapture : BZLogCapture
- (NSString *)buffer;
@end
