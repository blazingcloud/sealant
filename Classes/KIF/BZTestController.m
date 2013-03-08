//
//  BZTestController.m
//  Blazing Cloud
//
//  Created by Blazing Pair on 7/2/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "BZTestController.h"
#import "TestFlight.h"
#import "VSSpeechSynthesizer.h"

@implementation BZTestController {
    VSSpeechSynthesizer *synthesizer;
}

#define addKIFScenario(name) [self addScenario:[KIFTestScenario name]]

- (void)initializeScenarios {
    synthesizer = [VSSpeechSynthesizer new];
    [synthesizer setVolume:0.3];
}

- (NSString *)logsFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Logs"];
}

- (NSString *)logFile {
    NSString *logsFolder = [self logsFolder];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = nil;
    for (NSString *file in [fileManager enumeratorAtPath:logsFolder]) {
        NSLog(@"found log file: %@", file);
        fileName = file;
    }
    NSParameterAssert(fileName);
    return [logsFolder stringByAppendingPathComponent:fileName];
}

- (NSString *)completeTestLog {
    NSError *error = nil;
    NSString *completeTestLog = [NSString stringWithContentsOfFile:[self logFile]
                                                          encoding:NSUTF8StringEncoding
                                                             error:&error];
    NSParameterAssert(!error);
    return completeTestLog;
}

- (void)showLog:(NSString *)log {
    NSString *title = failureCount ? [NSString stringWithFormat:@"%d failures", failureCount] : @"All Tests Passed";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:log
                                                   delegate:self
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:@"Feedback", nil];
    [alert show];
}

- (void)completeInteractiveTesting {
    NSString *testLog = [self completeTestLog];
    [self performSelectorOnMainThread:@selector(showLog:) withObject:testLog waitUntilDone:NO];
    [TestFlight submitFeedback:testLog];
}

- (BOOL)shouldExitTests {
#if TARGET_IPHONE_SIMULATOR
    NSNumber *maxFailureCountToExit = [[[NSProcessInfo processInfo] environment]
                                       objectForKey:@"KIF_MAX_FAILURE_COUNT_TO_EXIT"];
    BOOL shouldExit = !maxFailureCountToExit || (failureCount <= [maxFailureCountToExit intValue]);
    return shouldExit;
#else
    return NO;
#endif
}

- (void)exitTests {
    [UIApplication sharedApplication].delegate = nil;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    exit(failureCount);
}

- (void)sayStepFailed {
    [self say:[self.currentStep description]];
}

- (void)sayResultsAndThankYou {
    NSString *message = nil;
    if (!failureCount) {
        message = [NSString stringWithFormat:@"All %d Tests Passed!", [self.scenarios count]];
    } else {
        NSUInteger firstFailure = [failedScenarioIndexes firstIndex];
        KIFTestScenario *firstFailedScenario = [scenarios objectAtIndex:firstFailure];
        NSString *failures = failureCount > 1 ? [NSString stringWithFormat:@"There were %d failures!", failureCount] : @"There was only 1 failure!";
        message = [NSString stringWithFormat:@"%@ First Failure is in %@", failures, [firstFailedScenario description]];
    }
    NSString *announcement = [NSString stringWithFormat:@"%@ Thank you for using automated tests.", message];
    [self say:announcement];
}

- (void)say:(NSString *)what {
    [synthesizer startSpeakingString:what];
}

- (void)endOfTestsCheckpoint {
    [TestFlight passCheckpoint:@"tests finished"];
    [self sayResultsAndThankYou];
    if (!failureCount) {
        [TestFlight passCheckpoint:@"tests succeeded"];
    }
}

- (void)clearPreviousLogs {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *logsFolder = [self logsFolder];
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:logsFolder isDirectory:&isDirectory]) {
        NSParameterAssert(isDirectory);
        [fileManager removeItemAtPath:logsFolder error:&error];
    }
    NSParameterAssert(!error);
}

- (void)startTesting {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self clearPreviousLogs];
    [self say:[NSString stringWithFormat:@"Starting %d test scenarios", [self.scenarios count]]];
    __block BZTestController *controller = self;
    [self startTestingWithCompletionBlock:^{
        [controller endOfTestsCheckpoint];
        if ([controller shouldExitTests]) {
            // Exit after the tests complete so that CI knows we're done
            [controller exitTests];
        } else {
            [controller completeInteractiveTesting];
        }
        controller = nil;
    }];
}

- (void)dealloc {
    synthesizer = nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView {
    [self exitTests];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([@"Feedback" isEqualToString:[alertView buttonTitleAtIndex:buttonIndex]]) {
        [TestFlight openFeedbackView];
    } else {
        [self exitTests];
    }
}
@end
