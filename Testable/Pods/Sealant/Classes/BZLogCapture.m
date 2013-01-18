//
//  BZLogCapture.m
//
//  Created by Paul Zabelin on 2/8/12.
//  Copyright (c) 2012 Blazing Cloud. All rights reserved.
//

#import "BZLogCapture.h"

@interface BZLogCapture ()
@property (nonatomic, strong) NSString *logPath;
@property (nonatomic, assign) int duplicateDescriptor;
@property (nonatomic, assign) BOOL shouldOutputWhatsLeft;
@end

@implementation BZLogCapture


- (id)init {
    self = [super init];
    if (self) {
        self.shouldOutputWhatsLeft = YES;
        _logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"logCapture.log"];
        _duplicateDescriptor = dup(STDERR_FILENO);
        if (_duplicateDescriptor > STDERR_FILENO) {
            if ((freopen([_logPath cStringUsingEncoding:NSASCIIStringEncoding],"w", stderr)) != NULL) {
                _redirected = YES;
            }
        } else {
            [NSException raise:@"test fixture"
                        format:@"LogCapture failed to duplicate the error descriptor:%d", _duplicateDescriptor];
        }
    }
    return self;
}

- (void)close {
    if (self.redirected) {
        dup2(self.duplicateDescriptor, STDERR_FILENO);
        close(self.duplicateDescriptor);
        self.redirected = NO;
    }
}

- (NSString *)buffer {
    fflush(stderr);
    NSError *error = nil;
    NSString *logString = [NSString stringWithContentsOfFile:self.logPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    if (error && !logString) {
        logString = [error description];
    }
    return logString;
}

- (NSString *)end {
    NSString *logString = [self buffer];
    [self close];
    return logString;
}

- (void)dealloc {
    if (self.shouldOutputWhatsLeft && self.redirected) {
        printf("%s", [[self end] cStringUsingEncoding:NSUTF8StringEncoding]);
    } else {
        [self close];
    }
}

@end

@implementation BZQueuetLogCapture
- (NSString *)buffer {
    return [super buffer];
}

- (void)dealloc {
    self.shouldOutputWhatsLeft = NO;
}
@end