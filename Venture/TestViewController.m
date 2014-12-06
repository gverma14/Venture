//
//  TestViewController.m
//  Venture
//
//  Created by Gaurav Verma on 12/5/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) viewDidLoad
{
    
    self.navigationController.navigationBar.translucent = NO;
    UIColor *color = self.view.backgroundColor;
    
    
    
    self.navigationController.navigationBar.barTintColor = color;
}


@end
