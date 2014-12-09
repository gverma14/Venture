//
//  GameBoard.m
//  Venture
//
//  Created by Gaurav Verma on 11/7/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard





-(int)colCount
{
    return 9;
}

-(int)rowCount
{
    return 12;
}

-(GameBoardTile *)retrieveTileAtRow:(int)row column:(int)col
{
    if (row >=0 && row < self.rowCount && col >=0 && col< self.colCount) {
        NSArray *tileRow = [self.tileRows objectAtIndex:row];
        GameBoardTile *tile = [tileRow objectAtIndex:col];
        return tile;
    }
    else {
        return nil;
    }
    
    
}


-(NSArray *)getNeighboringTiles:(GameBoardTile *)tile
{
    int row = tile.row;
    int col = tile.column;
    
    GameBoardTile *top,*bottom,*left,*right;
    
    top = [self retrieveTileAtRow:row-1 column:col];
    bottom = [self retrieveTileAtRow:row+1 column:col];
    left = [self retrieveTileAtRow:row column:col-1];
    right = [self retrieveTileAtRow:row column:col+1];
    
    
    NSMutableArray *neighbors = [[NSMutableArray alloc] init];
    
    
    if (top) {
        [neighbors addObject:top];
    }
    
    if (bottom) {
        [neighbors addObject:bottom];
    }
    
    if (left) {
        [neighbors addObject:left];
    }
    
    if (right) {
        [neighbors addObject:right];
    }
    
    
    return neighbors;
    
}

-(NSDictionary *)findLengthOfNeighbors:(GameBoardTile *)tile
{
    int row = tile.row;
    int col = tile.column;
    
    NSNumber *top, *bottom, *left, *right;
    
    
    
    NSMutableArray *previousTiles = [[NSMutableArray alloc] init];
    
    top = [NSNumber numberWithInt:[self findLengthOfChainAtRow:row-1 column:col withPreviousTiles:previousTiles]];
    [previousTiles removeAllObjects];
    
    bottom =[NSNumber numberWithInt:[self findLengthOfChainAtRow:row+1 column:col withPreviousTiles:previousTiles]];
    [previousTiles removeAllObjects];
    
    left = [NSNumber numberWithInt:[self findLengthOfChainAtRow:row column:col-1 withPreviousTiles:previousTiles]];
    [previousTiles removeAllObjects];
    
    right = [NSNumber numberWithInt:[self findLengthOfChainAtRow:row column:col+1 withPreviousTiles:previousTiles]];
    [previousTiles removeAllObjects];
    
    
    //NSArray *neighbors = [[NSArray alloc] initWithObjects:top,bottom,left,right, nil];
    
    NSDictionary *neighborLengths = @{@"top": top, @"bottom":bottom, @"left" :left, @"right" :right };
    
    
    return neighborLengths;
    
    
    
}



-(NSArray *)findHighestNeighboringTiles:(GameBoardTile *)tile
{
    int row = tile.row;
    int col = tile.column;
    
    
    NSDictionary *neighborLengths = [self findLengthOfNeighbors:tile];
    [self debugNeighborLengths:neighborLengths];
    
    //// Sorts the dictionary of lengths of neighboring chains and finds the highest chain key
    NSString *highestChainKey = [self findHighestChainKey:neighborLengths];
    NSMutableArray *highestNeighboringTiles = [[NSMutableArray alloc] init];
    
    
    /// Checks if the length of the highest chain is greater than zero
    if ([neighborLengths[highestChainKey]intValue] > 0) {
        
        NSArray *allHighestChainKeys = [neighborLengths allKeysForObject:neighborLengths[highestChainKey]];
        
        // loop through the all the neighboring keys that have the high number of chains
        // perform some logic
        for (NSString *oneHighestChainKey in allHighestChainKeys) {
            
            GameBoardTile *highestNeighboringTile;
            
            if ([oneHighestChainKey isEqualToString:@"top"]) {
                highestNeighboringTile = [self retrieveTileAtRow:row-1 column:col];
            }
            else if ([oneHighestChainKey isEqualToString:@"bottom"]) {
                highestNeighboringTile = [self retrieveTileAtRow:row+1 column:col];
            }
            else if ([oneHighestChainKey isEqualToString:@"left"]) {
                highestNeighboringTile = [self retrieveTileAtRow:row column:col-1];
                
            }
            else if ([oneHighestChainKey isEqualToString:@"right"]) {
                highestNeighboringTile = [self retrieveTileAtRow:row column:col+1];
            }
            
            
            BOOL companyAlreadyFound = NO;
            
            for (GameBoardTile *existingTile in highestNeighboringTiles) {
                if (existingTile.companyType == highestNeighboringTile.companyType) {
                    companyAlreadyFound = YES;
                    break;
                }
            }
            
            if (!companyAlreadyFound) {
                [highestNeighboringTiles addObject:highestNeighboringTile];

            }
        
            
        }
        
        
        
        
    }
    /// Else sets company type to neutral if all surrounding tiles are empty
    
    return highestNeighboringTiles;
    
}

-(void)debugNeighborLengths:(NSDictionary *)neighborLengths
{
    
    ///////// Debugging show the lengths of the neighbors
//    
//    int topLength = [neighborLengths[@"top"] intValue];
//    int bottomLength = [neighborLengths[@"bottom"] intValue];
//    int leftLength = [neighborLengths[@"left"] intValue];
//    int rightLength = [neighborLengths[@"right"] intValue];
//    
    //NSLog(@"top:%d bottom:%d left:%d right:%d", topLength, bottomLength, leftLength, rightLength);
    /////////
    
}


//// Given the dictionary of lengths, this returns the key for the highest neighbor chain length
-(NSString *)findHighestChainKey:(NSDictionary *)neighborLengths
{
    
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
    
    return highestKey;
    
}


// returns array of colors that were changed
-(void)changeNeighborsOfTile:(GameBoardTile *)tile toCompanyType:(int)companyType withPreviousTiles:(NSMutableArray *)previousTiles withChangedCompanyTiles:(NSMutableArray *)changedCompanyTiles
{
    if (tile.companyType != companyType) {
        tile.companyType = companyType;
    }
    NSArray *neighbors = [self getNeighboringTiles:tile];
    
    if (![previousTiles containsObject:tile]) {
        [previousTiles addObject:tile];
    }
    
    
    
    for (GameBoardTile *neighborTile in neighbors) {
        
        if (neighborTile) {
            if (neighborTile.companyType >= 0 && ![previousTiles containsObject:neighborTile]) {
                
                if (neighborTile.companyType != companyType) {
                    NSNumber *companyNumber = [NSNumber numberWithInt:neighborTile.companyType];
                    if (![changedCompanyTiles containsObject:companyNumber] && [companyNumber intValue] > 0) {
                        [changedCompanyTiles addObject:companyNumber];
                    }
                }
                
                neighborTile.companyType = companyType;
                [previousTiles addObject:neighborTile];
                [self changeNeighborsOfTile:neighborTile toCompanyType:companyType withPreviousTiles: previousTiles withChangedCompanyTiles:changedCompanyTiles];
            }
            
        }
        
        
    }
    
}


-(int)findLengthOfChainAtRow:(int)row column:(int)col withPreviousTiles:(NSMutableArray *)previousTiles
{
    
    GameBoardTile *thisTile = [self retrieveTileAtRow:row column:col];
    
    
    if (thisTile) {
        if (thisTile.companyType <= 0 || [previousTiles containsObject:thisTile]) {
            return 0;
        }
        else {
            
            int length = 1;
            
            [previousTiles addObject:thisTile];
            
            //top
            length+= [self findLengthOfChainAtRow:row-1 column:col  withPreviousTiles:previousTiles];
            
            
            //bottom
            length+= [self findLengthOfChainAtRow:row+1 column:col withPreviousTiles:previousTiles];
            
            //left
            length+= [self findLengthOfChainAtRow:row column:col-1 withPreviousTiles:previousTiles];
            
            //right
            length+= [self findLengthOfChainAtRow:row column:col+1 withPreviousTiles:previousTiles];
            
            return length;
            
            
            
            
            
            
            
        }
    
    }
    
    return 0;
    

    
}



-(NSMutableArray *)tileRows
{
    if (!_tileRows) {
        _tileRows = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.rowCount; i++) {
            
            NSMutableArray *tileRow = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < self.colCount; j++) {
                GameBoardTile *tile = [[GameBoardTile alloc] init];
                tile.row = i;
                tile.column = j;
                
                [tileRow addObject:tile];
                
            }
            
            [_tileRows addObject:tileRow];
            
        }
        
        
    }
    
    return _tileRows;
}

-(NSArray *)chainNumbersOnBoard:(int)totalCompanies
{
    
    NSMutableArray *chainNumbers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= totalCompanies; i ++) {
        
        [chainNumbers addObject:[NSNumber numberWithInt:0]];
    }
    
    
    for (int row = 0; row < self.rowCount; row++) {
        for (int col = 0; col < self.colCount; col++) {
            GameBoardTile *tile = [self retrieveTileAtRow:row column:col];
            
            if (tile.companyType > 0) {
                int currentNumber = [chainNumbers[tile.companyType] intValue];
                currentNumber++;
                
                chainNumbers[tile.companyType] = [NSNumber numberWithInt:currentNumber];
                
            }
        }
        
        
    }
    
    
    return chainNumbers;
    
    
    
}



@end
