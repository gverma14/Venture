//
//  Player.m
//  Venture
//
//  Created by Gaurav Verma on 11/20/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "Player.h"

@implementation Player

static const int placementTileCount = 6;

-(instancetype)initWithCompanies:(int)numCompanies tileBox:(PlacementTileBox *)tileBox
{
    self = [super init];
    
    self.numberOfCompanies = numCompanies;
    
    for (int i = 0 ; i < placementTileCount; i++) {
        PlacementTile *tile = [tileBox drawRandomTile];
        [self.placementTileStack addObject:tile];
        
        
    }
    
    return self;
    
}



-(NSMutableArray *)sharesOwned
{
    if (!_sharesOwned) {
        _sharesOwned = [[NSMutableArray alloc] initWithCapacity:self.numberOfCompanies+1];
        
        for (int i = 0; i <= self.numberOfCompanies; i++) {
            NSNumber *number = [NSNumber numberWithInt:0];
            [_sharesOwned addObject:number];
            
        }
        
        
        
        
    }
    
    return _sharesOwned;
}


-(NSMutableArray *)placementTileStack
{
    if (!_placementTileStack) {
        _placementTileStack = [[NSMutableArray alloc] init];
        
        
        
        
    }
    
    
    return _placementTileStack;
}

-(void)replacePlacementTile:(PlacementTile *)oldPlacementTile fromTileBox:(PlacementTileBox *)tileBox
{
    if ([self.placementTileStack containsObject:oldPlacementTile]) {
        int index = [self.placementTileStack indexOfObject:oldPlacementTile];
        
        [self.placementTileStack removeObjectAtIndex:index];
        
        PlacementTile *newPlacementTile = [tileBox drawRandomTile];
        
        if (newPlacementTile) {
            [self.placementTileStack insertObject:newPlacementTile atIndex:index];
        }
        
    }
    
    
    
}




@end
