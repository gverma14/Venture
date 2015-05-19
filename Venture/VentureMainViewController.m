//
//  VentureMainViewController.m
//  Venture
//
//  Created by Gaurav Verma on 10/16/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "VentureMainViewController.h"
#import "MainMenuButton.h"

@interface VentureMainViewController ()

@end

@implementation VentureMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //UIButton *mainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    MainMenuButton *mainButton = [[MainMenuButton alloc] init];// [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
//    UIButton  *mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
    
    mainButton.frame = CGRectMake(0, 0, 100, 40);
    
    CGPoint center = self.view.center;
    center.y += mainButton.frame.size.height*2;
    
    mainButton.center = center;
    
    //mainButton.showsTouchWhenHighlighted = YES;
    
    
   // NSLog(@"%d", mainButton.buttonType);
    
    
    [mainButton setTitle:@"Play" forState:UIControlStateNormal];
    [mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mainButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    
    //mainButton.backgroundColor = [UIColor blueColor];
    //mainButton.highlighted = YES;
    mainButton.enabled = YES;
    [self.view addSubview:mainButton];
    
    [mainButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[mainButton sizeToFit];
}



- (void)playButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"playSegue" sender:sender];
    //NSLog(@"pressed");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"playSegue"]) {
//        
//        UINavigationController *navigation = segue.destinationViewController;
//        
//        navigation.navigationBar.barTintColor = [UIColor whiteColor];
//        
//        
//        
//    }
//}

@end
