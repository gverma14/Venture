//
//  MarketViewController.h
//  Venture
//
//  Created by Gaurav Verma on 12/18/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@protocol MarketViewControllerDelegate <NSObject>

-(void)returnToBoard;

@end

@interface MarketViewController : UIViewController

@property (strong, nonatomic) Game *game;
@property (nonatomic, weak) id <MarketViewControllerDelegate> delegate;
@end
