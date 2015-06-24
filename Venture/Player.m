//
//  Player.m
//  Venture
//
//  Created by Gaurav Verma on 11/20/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "Player.h"
#import "GameBoardTile.h"
@implementation Player

const int placementTileCount = 6;
const int startingCash = 60;


// Custom initializer for Player class that adds a starting set of PlacementTiles
-(instancetype)initWithCompanies:(int)numCompanies tileBox:(PlacementTileBox *)tileBox
{
    self = [super init];
    
    
    // Draw a random placement tile from the tilebox and then add it to the player's stack
    for (int i = 0 ; i < placementTileCount; i++) {
        PlacementTile *tile = [tileBox drawRandomTile];
        [self.placementTileStack addObject:tile];
        
    }
    
    // set starting cash value
    _cash = startingCash;
    
    // Initialize array for keeping track of shares owned for each company type
    _sharesOwned = [[NSMutableArray alloc] initWithCapacity:numCompanies+1];
    for (int i=0; i <= numCompanies; i++) {
        
        NSNumber *number = [NSNumber numberWithInt:0];
        [_sharesOwned addObject:number];
    }
    
    
    
    return self;
    
}


// Getter method for the placementTileStack array
-(NSMutableArray *)placementTileStack
{
    if (!_placementTileStack) {
        _placementTileStack = [[NSMutableArray alloc] init];
        
    }
    return _placementTileStack;
}


// Method that is called when a PlacementTile is drawn and needs to be replaced from the PlacementTileBox
// Method takes the parameters for the old PlacementTile object to be removed and the PlacementTileBox to
// be drawn from.
// In addition,
-(void)replacePlacementTile:(PlacementTile *)oldPlacementTile fromTileBox:(PlacementTileBox *)tileBox usingBoard:(GameBoard *)board withChainLimit:(int)limit
{
    if ([self.placementTileStack containsObject:oldPlacementTile]) {
        int index = (int)[self.placementTileStack indexOfObject:oldPlacementTile];
        
        [self.placementTileStack removeObjectAtIndex:index];
        
        
        int limitCount;
        PlacementTile *newPlacementTile = nil;
        do {
           // NSLog(@"new placement tile");
            limitCount = 0;
            newPlacementTile = [tileBox drawRandomTile];
            
            if (newPlacementTile) {
                GameBoardTile *gameTile = [[GameBoardTile alloc] init];
                gameTile.row = newPlacementTile.row;
                gameTile.column = newPlacementTile.col;
                NSArray *greaterNeighborTiles = [board findNeighboringTilesOf:gameTile greaterThan:limit];
                limitCount = (int)[greaterNeighborTiles count];
                
                
            }

        } while (limitCount > 1);
        
        
        if (newPlacementTile) {
            [self.placementTileStack insertObject:newPlacementTile atIndex:index];
        }
        
    }
    
    
    
}



@end
