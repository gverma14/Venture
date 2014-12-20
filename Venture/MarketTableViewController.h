//
//  MarketTableViewController.h
//  Venture
//
//  Created by Gaurav Verma on 12/6/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Market.h"
#import "Player.h"
#import "Game.h"


@protocol tableDelegate

@property (strong, nonatomic) Game *thisGame;

@end

@interface MarketTableViewController : UITableViewController

@property (nonatomic, strong) Game *game;

@end
