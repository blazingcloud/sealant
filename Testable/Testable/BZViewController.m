//
//  BZViewController.m
//  Testable
//
//  Created by Blazing Pair on 1/15/13.
//  Copyright (c) 2013 Blazing Pair. All rights reserved.
//

#import "BZViewController.h"

@interface BZViewController ()

@end

@implementation BZViewController

- (IBAction)press:(id)sender {
    UIButton *pressMeButton = (UIButton *)sender;
    [pressMeButton setTitle:@"Thank you!" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
