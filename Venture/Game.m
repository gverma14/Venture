//
//  Game.m
//  Venture
//
//  Created by Gaurav Verma on 10/30/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "Game.h"
#import "PlacementTile.h"
#import "PlacementTileBox.h"

@interface Game()

@property (strong, nonatomic) PlacementTileBox *tileBox;
@property (strong, nonatomic) NSMutableArray *chainsInPlay;


@end


@implementation Game

-(instancetype)init
{
    self = [super init];

    
    return self;
    
}

-(NSMutableArray *)chainsInPlay
{
    if (!_chainsInPlay) {
        _chainsInPlay = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 7; i++) {
            NSNumber *num = [NSNumber numberWithInt:i];
            [_chainsInPlay addObject:num];
            
        }
    }
    
    return _chainsInPlay;
}

-(GameBoard *)board
{
    if (!_board) {
        _board = [[GameBoard alloc] init];
    }
    
    return _board;
}


-(int)tileCount
{
    if (!_tileCount) {
        _tileCount = [self.tileBox tilesLeft];
    }
    
    return _tileCount;
    
}

-(int)placementTileCount
{
    return 6;
}


-(int)numberColumns
{
    return self.board.colCount;
}

-(int)numberRows
{
    return self.board.rowCount;
}


-(PlacementTileBox *)tileBox
{
    if (!_tileBox) {
        _tileBox = [[PlacementTileBox alloc] initWithRow:self.board.rowCount column:self.board.colCount];
    }
    
    return _tileBox;
}


-(NSMutableArray *)placementTileStack
{
    if (!_placementTileStack) {
        _placementTileStack = [[NSMutableArray alloc] init];
        
        
        for (int i = 0 ; i < self.placementTileCount; i++) {
            PlacementTile *placementTile = [self.tileBox drawRandomTile];
            
            [_placementTileStack addObject:placementTile];
            
        }
        
        
    }
    
    
    return _placementTileStack;
}




- (void)replaceTileAtIndex:(int)index
{
    if (index < [self.placementTileStack count]) {
        if ([self.placementTileStack objectAtIndex:index]) {
            [self.placementTileStack removeObjectAtIndex:index];
            PlacementTile *placementTile = [self.tileBox drawRandomTile];
            if (placementTile) {
                [self.placementTileStack insertObject:placementTile atIndex:index];
            }
        }
    }
    
    
    
//    
//    if (self.tileBox.tilesLeft) {
//        PlacementTile *placementTile = [self.tileBox drawRandomTile];
//        NSLog(@"Adding placement Tile with %d tiles left", self.tileBox.tilesLeft);
//        [self.placementTileStack setObject:placementTile atIndexedSubscript:index];
//        
//    }
//    else {
//        
//        [self.placementTileStack removeObjectAtIndex:index];
//    }
//    

    
}


-(void)chooseTileAtRow:(int)row column:(int)col
{
    
    
    PlacementTile *oldPlacementTile = nil;
    
    //Finds the matching placement tile at the recently selected gameboard tile
    for (PlacementTile *placementTile in self.placementTileStack) {
        
        if (row == placementTile.row && col == placementTile.col) {
            oldPlacementTile = placementTile;
            break;
        }
        
        
    }
    
    // check if the current placement tile exists
    if (oldPlacementTile) {
         
         
        
        int index = [self.placementTileStack indexOfObject:oldPlacementTile];
        
        
        
         //Checks if the placement tile exists at that row col selected and draws a new placement tile
        if ([self.placementTileStack objectAtIndex:index]) {
            [self.placementTileStack removeObjectAtIndex:index];
            PlacementTile *newPlacementTile = [self.tileBox drawRandomTile];
            if (newPlacementTile) {
                [self.placementTileStack insertObject:newPlacementTile atIndex:index];
            }
        }
        
        /////////////////////////////////////////////////////
        
        // Retrieves the game tile at the spot just selected
        GameBoardTile *tile = [self retrieveTileAtRow:row column:col];
        
         
         // Makes sure the spot is empty
        if (tile.companyType == -1) {
            
            
            
            // Retrieve the lengths of chains neighboring the spot just selected
            NSDictionary *neighborLengths = [self.board findLengthOfNeighborsAtRow:row column:col];
            
            
            ///////// Debugging show the lengths of the neighbors
            int topLength = [neighborLengths[@"top"] intValue];
            int bottomLength = [neighborLengths[@"bottom"] intValue];
            int leftLength = [neighborLengths[@"left"] intValue];
            int rightLength = [neighborLengths[@"right"] intValue];
            
            NSLog(@"top:%d bottom:%d left:%d right:%d", topLength, bottomLength, leftLength, rightLength);
            /////////
            
            
            

            // Sorts the dictionary keys in terms of lowest to highest chain lengths
            NSArray *sortedKeys = [neighborLengths keysSortedByValueUsingComparator:^NSComparisonResult(id object1, id object2) {
                
                NSNumber *obj1 = (NSNumber *) object1;
                NSNumber *obj2 = (NSNumber *) object2;
                
                
                if ([obj1 intValue] > [obj2 intValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 intValue] < [obj2 intValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            
            
            }];
            
            
            // Finds the highest key
            NSString *highestKey = sortedKeys[3];
            
            
            
            // Checks to see that at least one tile exists in a neighboring position else make its a neutral tile
            if ([neighborLengths[highestKey]intValue] != 0) {
                
                
                
                // Retrieves all the locations where the chains are equal length
                NSArray *allHighKeys = [neighborLengths allKeysForObject:neighborLengths[highestKey]];
            
            
                NSMutableArray *highestNeighboringTiles = [[NSMutableArray alloc] init];
                
                // commit test
                
                
                // loop through the all the neighboring keys that have the high number of chains
                // perform some logic
                for (NSString *highKey in allHighKeys) {
                    
                    GameBoardTile *highestNeighboringTile;
                    
                    if ([highKey isEqualToString:@"top"]) {
                        highestNeighboringTile = [self.board retrieveTileAtRow:row-1 column:col];
                    }
                    else if ([highKey isEqualToString:@"bottom"]) {
                        highestNeighboringTile = [self.board retrieveTileAtRow:row+1 column:col];
                    }
                    else if ([highKey isEqualToString:@"left"]) {
                        highestNeighboringTile = [self.board retrieveTileAtRow:row column:col-1];
                        
                    }
                    else if ([highKey isEqualToString:@"right"]) {
                        highestNeighboringTile = [self.board retrieveTileAtRow:row column:col+1];
                    }
                    
//                        if (highestNeighboringTile.companyType == 0 && [self.chainsInPlay count]) {
//                            NSLog(@"changing company type");
//                            
//                            int index = [self generateRandomNumber:0 end:[self.chainsInPlay count]-1];
//                            
//                            
//                            tile.companyType = [[self.chainsInPlay objectAtIndex:index] intValue];
//                            
//                            highestNeighboringTile.companyType = tile.companyType;
//                            
//                            [self.chainsInPlay removeObjectAtIndex:index];
//                        }
                    
                    
                    [highestNeighboringTiles addObject:highestNeighboringTile];
                    
                }
                    
                // set default tile value to zero
                tile.companyType = 0;
                
                
                // Check all the neighboring tiles and find the company type that matches the logic to apply
                for (GameBoardTile *highestNeighboringTile in highestNeighboringTiles) {
                    
                    if (highestNeighboringTile.companyType > 0) {
                        tile.companyType = highestNeighboringTile.companyType;
                        break;
                    }
                    
                    
                }
                
                // If no company type is found generate a random company type
                if (!tile.companyType) {
                    //NSLog(@"changing company type");
                    
                    if ([self.chainsInPlay count]) {
                        int index = [self generateRandomNumber:0 end:[self.chainsInPlay count]-1];
                    
                        NSLog(@"color %d", [[self.chainsInPlay objectAtIndex:index] intValue]);
                        
                        tile.companyType = [[self.chainsInPlay objectAtIndex:index] intValue];
                    
                        
                        [self.chainsInPlay removeObjectAtIndex:index];
                    }
                    
                }
                
                
                NSMutableArray *previousTiles = [[NSMutableArray alloc] initWithObjects:tile, nil];
                
                [self.board changeNeighborsAtRow:row column:col toCompanyType:tile.companyType withPreviousTiles:previousTiles];
                
                
                ///////////////////////
                
                    
                
            }
            else {
                tile.companyType = 0;
                //NSLog(@"changing company type");
                
            }
            
            
            
        
        
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}





-(int) generateRandomNumber:(int)begin end:(int) end {
    
    return arc4random()%(end+1 - begin) +begin;
    
}




-(GameBoardTile *)retrieveTileAtRow:(int)row column:(int)col
{
    GameBoardTile *tile = [self.board retrieveTileAtRow:row column:col];
    
    return tile;
    
}




@end
