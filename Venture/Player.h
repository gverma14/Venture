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

@interface Player : NSObject

@property (nonatomic) int cash;
@property (nonatomic, strong) NSMutableArray *sharesOwned;
@property (nonatomic) int numberOfCompanies;
@property (strong, nonatomic) NSMutableArray *placementTileStack;


-(instancetype)initWithCompanies:(int)numCompanies tileBox:(PlacementTileBox *)tileBox;

-(void)replacePlacementTile:(PlacementTile *)oldPlacementTile fromTileBox:(PlacementTileBox *)tileBox;

@end
