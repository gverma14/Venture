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

@interface MarketTableViewController : UITableViewController


@property (nonatomic, strong) Market *market;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) Player *currentPlayer;
@property (nonatomic) BOOL marketIsOpen;

@property (nonatomic, strong) NSArray *chainsInPlay;


@end
