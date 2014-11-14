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


-(NSArray *)getNeighboringTilesAtRow:(int)row column:(int)col
{
    
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


-(void)placeTile:(GameBoardTile *)tile
{
    NSDictionary *neighborLengths = [self findLengthOfNeighbors:tile];
    
    //// Sorts the dictionary of lengths of neighboring chains and finds the highest chain key
    NSString *highestChainKey = [self findHighestChainKey:neighborLengths];
    
    
    /// Checks if the length of the highest chain is greater than zero
    if (neighborLengths[highestChainKey] > 0) {
        
        
        
        
        
        
    }
    else {
        
    }
    
    
    
    
    
    
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


-(void)changeNeighborsAtRow:(int)row column:(int)column toCompanyType:(int)companyType withPreviousTiles:(NSMutableArray *)previousTiles
{
    NSArray *neighbors = [self getNeighboringTilesAtRow:row column:column];
    
    for (GameBoardTile *tile in neighbors) {
        
        if (tile) {
            if (tile.companyType >= 0 && ![previousTiles containsObject:tile]) {
                tile.companyType = companyType;
                [previousTiles addObject:tile];
                [self changeNeighborsAtRow:tile.row column:tile.column toCompanyType:companyType withPreviousTiles:previousTiles];
            }
            
        }
        
        
    }
    
}


-(int)findLengthOfChainAtRow:(int)row column:(int)col withPreviousTiles:(NSMutableArray *)previousTiles
{
    
    GameBoardTile *thisTile = [self retrieveTileAtRow:row column:col];
    
    
    if (thisTile) {
        if (thisTile.companyType == -1 || [previousTiles containsObject:thisTile]) {
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
    
    
//    if (target.companyType == -1) {
//        return 0;
//    }
//    else {
//        NSArray *neighbors = target.neighboringTiles;
//        int length = 1;
//        
//        for (id obj in neighbors) {
//            if ([obj isKindOfClass:[GameBoardTile class]]) {
//                GameBoardTile *neighboringTile = (GameBoardTile *)obj;
//                if (neighboringTile != target) {
//                    length += [self findLengthOfChainAtTile:neighboringTile fromSender:target];
//
//                }
//                
//                
//                
//            }
//        }
//        
//    }
    
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


@end
