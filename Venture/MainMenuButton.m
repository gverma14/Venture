//
//  MainMenuButton.m
//  Venture
//
//  Created by Gaurav Verma on 10/23/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "MainMenuButton.h"

@implementation MainMenuButton





-(void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    
    path.lineWidth = 3;
    [path stroke];
}




@end
