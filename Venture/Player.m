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

static const int placementTileCount = 6;

-(instancetype)initWithCompanies:(int)numCompanies tileBox:(PlacementTileBox *)tileBox
{
    self = [super init];
    
    self.numberOfCompanies = numCompanies;
    
    for (int i = 0 ; i < placementTileCount; i++) {
        PlacementTile *tile = [tileBox drawRandomTile];
        [self.placementTileStack addObject:tile];
        
        
    }
    
    self.cash = 60;
    
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

//-(int)checkPlacementTile:(PlacementTile *)placementTile usingBoard:(GameBoard *)board withChainLimit:(int)limit
//{
//    int limitCount = 0;
//    GameBoardTile *tile = [board retrieveTileAtRow:placementTile.row column:placementTile.col];
//    NSDictionary *neighborLengths = [board findLengthOfNeighbors:tile];
//    for (id key in neighborLengths) {
//        
//        if ([neighborLengths[key] intValue] >= limit) {
//            limitCount++;
//        }
//    }
//    
//    return limitCount;
//}




@end
