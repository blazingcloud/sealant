//
//  BZTestFlightStub.m
//
//
//  Created by Paul Zabelin on 8/17/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "TestFlight.h"

#undef TFLog
void TFLog(id fmt, ...);
void TFLog(id fmt, ...) {
    @throw @"TestFlight Log should be redirected to debug log during tests";
}

@implementation TestFlight

/**
 * Add custom environment information
 * If you want to track custom information such as a user name from your application you can add it here
 *
 * @param information A string containing the environment you are storing
 * @param key The key to store the information with
 */
+ (void)addCustomEnvironmentInformation:(NSString *)information forKey:(NSString*)key {
    DLogObject(@{key:information});
}

/**
 * Starts a TestFlight session
 *
 * @param teamToken Will be your team token obtained from https://testflightapp.com/dashboard/team/edit/
 */
+ (void)takeOff:(NSString *)teamToken {
    DLogObject(teamToken);
}

/**
 * Sets custom options
 *
 * @param options NSDictionary containing the options you want to set available options are described below
 *
 *   Option                      Accepted Values                 Description
 *   reinstallCrashHandlers      [ NSNumber numberWithBool:YES ] Reinstalls crash handlers, to be used if a third party
 *                                                               library installs crash handlers overtop of the TestFlight Crash Handlers
 *   logToConsole                [ NSNumber numberWithBool:YES ] YES - default, sends log statements to Apple System Log and TestFlight log
 *                                                               NO  - sends log statements to TestFlight log only
 *   logToSTDERR                 [ NSNumber numberWithBool:YES ] YES - default, sends log statements to STDERR when debugger is attached
 *                                                               NO  - sends log statements to TestFlight log only
 *   sendLogOnlyOnCrash          [ NSNumber numberWithBool:YES ] NO  - default, sends logs to TestFlight at the end of every session
 *                                                               YES - sends logs statements to TestFlight only if there was a crash
 */
+ (void)setOptions:(NSDictionary*)options {
    DLogObject(options);
}

/**
 * Track when a user has passed a checkpoint after the flight has taken off. Eg. passed level 1, posted high score
 *
 * @param checkpointName The name of the checkpoint, this should be a static string
 */
+ (void)passCheckpoint:(NSString *)checkpointName {
    DLogObject(checkpointName);
}

/**
 * Opens a feedback window that is not attached to a checkpoint
 */
+ (void)openFeedbackView {
    DLogLine;
}

/**
 * Submits custom feedback to the site. Sends the data in feedback to the site. This is to be used as the method to submit
 * feedback from custom feedback forms.
 *
 * @param feedback Your users feedback, method does nothing if feedback is nil
 */
+ (void)submitFeedback:(NSString*)feedback {
    DLogObject(feedback);
}

/**
 * Sets the Device Identifier.
 * The SDK no longer obtains the device unique identifier. This method should only be used during testing so that you can
 * identify a testers test data with them. If you do not provide the identifier you will still see all session data, with checkpoints
 * and logs, but the data will be anonymized.
 * It is recommended that you only use this method during testing. We also recommended that you wrap this method with a pre-processor
 * directive that is only active for non-app store builds.
 * #ifndef RELEASE
 * [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
 * #endif
 *
 * @param deviceIdentifier The current devices device identifier
 */
+ (void)setDeviceIdentifier:(NSString*)deviceIdentifer {
    DLogObject(deviceIdentifer);
}


@end
