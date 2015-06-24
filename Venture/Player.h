//
//  Player.h
//  Venture
//
//  Created by Gaurav Verma on 11/20/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlacementTile.h"
#import "PlacementTileBox.h"
#import "GameBoard.h"
@interface Player : NSObject

@property (nonatomic) int cash;
@property (nonatomic, strong) NSMutableArray *sharesOwned;

@property (strong, nonatomic) NSMutableArray *placementTileStack;


-(instancetype)initWithCompanies:(int)numCompanies tileBox:(PlacementTileBox *)tileBox;

-(void)replacePlacementTile:(PlacementTile *)oldPlacementTile fromTileBox:(PlacementTileBox *)tileBox usingBoard:(GameBoard *)board withChainLimit:(int)limit;



@end
