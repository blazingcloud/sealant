//
//  KIFTestScenario+EXAdditions.m
//  Testable
//
//  Created by Blazing Pair on 1/15/13.
//  Copyright (c) 2013 Blazing Cloud. All rights reserved.
//

#import <KIFTestStep.h>
#import <KIFTestScenario.h>

@implementation KIFTestScenario (EXAdditions)

+ (id)scenarioToPressTheButton {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can press the button."];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Press Me"]];
  
  // Verify that the login succeeded
  [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Thank you!"]];
  return scenario;
}

@end
