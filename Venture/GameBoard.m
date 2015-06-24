//
//  GameBoard.m
//  Venture
//
//  Created by Gaurav Verma on 11/7/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "GameBoard.h"

@interface GameBoard()

@property (strong, nonatomic) NSMutableArray *tileRows;

@end


@implementation GameBoard

const int columnCount = 9;
const int rowCount = 12;
NSString * const topKey = @"top";
NSString * const bottomKey = @"bottom";
NSString * const leftKey = @"left";
NSString * const rightKey = @"right";



#pragma mark PUBLIC


// Returns number of columns on GameBoard
+(int)colCount
{
    return columnCount;
}

// Returns number of rows on Gameboard
+(int)rowCount
{
    return rowCount;
}


#pragma mark ACCESS_TILES

// Function to get a specific GameBoardTile object at the specifed row and column number
// Takes two integers row and column numbers as arguments
// Returns a GameBoardTile object, checks if the indices are out of bounds
// Returns nil if indices invalid
-(GameBoardTile *)retrieveTileAtRow:(int)row column:(int)col
{
    // Check indices to be within bounds of grid
    if (row >=0 && row < rowCount && col >=0 && col< columnCount) {
        // Access internal 2D array
        NSArray *tileRow = [self.tileRows objectAtIndex:row];
        GameBoardTile *tile = [tileRow objectAtIndex:col];
        return tile;
    }
    else {
        return nil;
    }    
    
}


// Function to get the surrounding GameBoardTile objects
// Takes as an argument a GameBoardTile object
// Returns an array of the GameBoard Tile objects in order top, bottom, left, right
-(NSArray *)getNeighboringTiles:(GameBoardTile *)tile
{
    
    int row = tile.row;
    int col = tile.column;
    
    GameBoardTile *top,*bottom,*left,*right;
    
    // Retrieve tiles in surrounding spots
    top = [self retrieveTileAtRow:row-1 column:col];
    bottom = [self retrieveTileAtRow:row+1 column:col];
    left = [self retrieveTileAtRow:row column:col-1];
    right = [self retrieveTileAtRow:row column:col+1];
    
    
    // Add GameBoardTiles at spots if non nil values returned
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




// Method to determine the surrounding tile or tiles that have the highest chain length
// Returns multiple tiles if two or more surrounding tiles have the highest chain length
// Takes as argument a GameBoardTile object
// Returns an NSArray of surrounding GameBoardTile objects with the highest chain length
-(NSArray *)findHighestNeighboringTiles:(GameBoardTile *)tile
{
    int row = tile.row;
    int col = tile.column;
    
    // Retrieve dictionary of length of chains of surrounding neighbors of specified GameBoardTile
    NSDictionary *neighborLengths = [self findLengthOfNeighbors:tile];
    
    //// Sorts the dictionary of lengths of neighboring chains and finds the highest chain key
    NSString *highestChainKey = [self findHighestChainKey:neighborLengths];
    
    // Initialize empty array to find the neighboring GameBoardTile objects with the highest chains
    NSMutableArray *highestNeighboringTiles = [[NSMutableArray alloc] init];
    
    
    /// Checks if the length of the highest chain is greater than zero
    if ([neighborLengths[highestChainKey]intValue] > 0) {
        
        NSArray *allHighestChainKeys = [neighborLengths allKeysForObject:neighborLengths[highestChainKey]];
        
        // loop through the all the neighboring keys that have the high number of chains
        for (NSString *oneHighestChainKey in allHighestChainKeys) {
            
            GameBoardTile *highestNeighboringTile;
            
            
            // Determine which neighbor corresponds to the specific key
            if ([oneHighestChainKey isEqualToString:topKey]) {
                highestNeighboringTile = [self retrieveTileAtRow:row-1 column:col];
            }
            else if ([oneHighestChainKey isEqualToString:bottomKey]) {
                highestNeighboringTile = [self retrieveTileAtRow:row+1 column:col];
            }
            else if ([oneHighestChainKey isEqualToString:leftKey]) {
                highestNeighboringTile = [self retrieveTileAtRow:row column:col-1];
                
            }
            else if ([oneHighestChainKey isEqualToString:rightKey]) {
                highestNeighboringTile = [self retrieveTileAtRow:row column:col+1];
            }
            
            
            BOOL companyAlreadyFound = NO;
            
            // Check if the specific neighboring GameBoardTile has already been added
            for (GameBoardTile *existingTile in highestNeighboringTiles) {
                if (existingTile.companyType == highestNeighboringTile.companyType) {
                    companyAlreadyFound = YES;
                    break;
                }
            }
            
            // If not already added, add it to the highestNeighboringTiles array
            if (!companyAlreadyFound) {
                [highestNeighboringTiles addObject:highestNeighboringTile];

            }
        
            
        }
        
        
        
        
    }
    /// Else sets company type to neutral if all surrounding tiles are empty
    
    return highestNeighboringTiles;
    
}


// Finds the surrounding GameBoardTile objects that have chains at their locations
// greater than a specified chain length
// Takes a GameBoardTile object from which the surrounding tiles will be inspected
// and an integer value for the chain length threshold
// Returns an NSArray of GameBoardTile objects that have chains that are greater than the chain length
// Includes checks for surrounding tiles that are the same company type
// Returns empty array if surrounding tiles are the same company type as the tile passed in
-(NSArray *)findNeighboringTilesOf:(GameBoardTile *)tile greaterThan:(int)chainLength
{
    // Get a dictionary of the lengths of all the neighboring tiles
    NSDictionary *neighborLengths = [self findLengthOfNeighbors:tile];
    
    // Initialize an empty array to add the tiles that pass the threshold
    NSMutableArray *greaterTiles = [[NSMutableArray alloc] init];
    
    // Find and create an NSSet out of the keys of the values that are higher than the specified chainLength
    NSSet *neighborKeys = [neighborLengths keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        
        
        if ([obj intValue] >= chainLength) {
            return YES;
        }
        else {
            return NO;
        }
        
    }];
    
    int row = tile.row;
    int column = tile.column;
    
    
    // Enumerate through the keys that passed the threshold test
    for (id key in neighborKeys) {
        
        GameBoardTile *neighboringTile;
        
        // Determine which neighbor corresponds to each key
        if ([key isEqualToString:topKey]) {
            neighboringTile = [self retrieveTileAtRow:row-1 column:column];
        }
        else if ([key isEqualToString:bottomKey]){
            neighboringTile = [self retrieveTileAtRow:row+1 column:column];
        }
        else if ([key isEqualToString:leftKey]){
            neighboringTile = [self retrieveTileAtRow:row column:column-1];
        }
        else if ([key isEqualToString:rightKey]) {
            neighboringTile = [self retrieveTileAtRow:row column:column+1];
        }
        
        
        // Ensure that the neighbor's company type is not equal to this tile's company type and also
        // the neighbor is not the same company type as another neighbor that has already been added
        // (This ensures it is not part of the same chain)
        if (neighboringTile.companyType != tile.companyType) {
            
            
            // Search through the greaterTiles array for any indices of objects that have the same companyType as the GameBoardTile object to be added
            NSIndexSet *indices = [greaterTiles indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                
                GameBoardTile *otherTile = (GameBoardTile *)obj;
                
                if (otherTile.companyType == neighboringTile.companyType) {
                    *stop = YES;
                    return YES;
                }
                else {
                    return NO;
                }
                
                
            }];
            
            // If no indices are found, it is ensured that this is a unique company type, therefore this can be added to the array
            if (![indices count]) {
                [greaterTiles addObject:neighboringTile];
            }
            
            
            
            
        }
        
        
    }
    
    return greaterTiles;
    
    
    
    
    
    
}

#pragma mark CHAIN_MANAGEMENT

// Recursively change the surrounding tiles of an existing GameBoardTile to a specified company type
// The method only changes the company type of surrounding GameBoardTiles if they are eligible
// Eligible GameBoardTile objects are those that are either "marked" (company type of 0) or have a
// valid company type (greater than 0)
// Takes as argument the starting GameBoardTile object, the company type to change to as an integer,
// an NSArray to keep track of the GameBoardTile objects that have been changed
// an NSarray to keep track of the company types that have been removed from the board if any
// GameBoardTile objects company types have been changed
-(void)changeNeighborsOfTile:(GameBoardTile *)tile toCompanyType:(int)companyType withPreviousTiles:(NSMutableArray *)previousTiles withChangedCompanyTiles:(NSMutableArray *)changedCompanyTiles
{
    // Checks if the specified tile is the company type desired, otherwise corrects it
    if (tile.companyType != companyType) {
        tile.companyType = companyType;
    }
    
    // Retrieves the neighboring tiles of the specified GameBoardTile
    NSArray *neighbors = [self getNeighboringTiles:tile];
    
    
    // If the specified tile has not already been changed, add it to the changed tiles array of previous tiles
    if (![previousTiles containsObject:tile]) {
        [previousTiles addObject:tile];
    }
    
    
    
    for (GameBoardTile *neighborTile in neighbors) {
        
        if (neighborTile) {
            
            // If a neighboring tile exists and has a company type, and also has not already been changed
            // Change its company type
            if (neighborTile.companyType >= 0 && ![previousTiles containsObject:neighborTile]) {
                
                
                
                if (neighborTile.companyType != companyType) {
                    
                    // Store the neighboring GameBoardTile old companyType in the changedCompanyTiles array
                    // if it does not already exist in there
                    NSNumber *companyNumber = [NSNumber numberWithInt:neighborTile.companyType];
                    if (![changedCompanyTiles containsObject:companyNumber] && [companyNumber intValue] > 0) {
                        [changedCompanyTiles addObject:companyNumber];
                    }
                }
                
                // Change the neighboring tiles company type and add it to the array of changed tiles
                neighborTile.companyType = companyType;
                [previousTiles addObject:neighborTile];
                
                // Change the neighbors of the neighboring tile
                [self changeNeighborsOfTile:neighborTile toCompanyType:companyType withPreviousTiles: previousTiles withChangedCompanyTiles:changedCompanyTiles];
            }
            
        }
        
        
    }
    
}



// Recursively traverse through the longest contiguous chain of the same company type starting at a specific
// row and column
// Takes as arguments two integers, row and column
// and an NSArray to keep track of the GameBoardTiles that have been traversed
-(void)traverseChainAtRow:(int)row column:(int)col withPreviousTiles:(NSMutableArray *)previousTiles
{
    GameBoardTile *thisTile = [self retrieveTileAtRow:row column:col];
    
    
    // If a tile exists at the specified row and column indices, check if the tile has a company type
    // and check if not already added to the chain array
    // Then traverse through its surrounding neighbors
    if (thisTile) {
        if (!(thisTile.companyType <=0 || [previousTiles containsObject:thisTile])) {
            [previousTiles addObject:thisTile];
            [self traverseChainAtRow:row-1 column:col withPreviousTiles:previousTiles];
            [self traverseChainAtRow:row+1 column:col withPreviousTiles:previousTiles];
            [self traverseChainAtRow:row column:col-1 withPreviousTiles:previousTiles];
            [self traverseChainAtRow:row column:col+1 withPreviousTiles:previousTiles];
            
        }
        
    }
}


#pragma mark SURVEY_BOARD

// Method to determine the length of chains of each of the company types on the board
// Takes the argument for the total companies that exist
// Returns an array with indices from 0 to an integer representing the highest company type
// The last index is equal to the value of totalCompanies
// Each company type index corresponds to the length of its corresponding chain on the board
// A value of zero indicates that the chain does not exist on the board
-(NSArray *)chainNumbersOnBoard:(int)totalCompanies
{
    
    NSMutableArray *chainNumbers = [[NSMutableArray alloc] init];
    
    
    // Create an empty array chainNumbers that has indices 0 to totalCompanies
    for (int i = 0; i <= totalCompanies; i ++) {
        
        [chainNumbers addObject:[NSNumber numberWithInt:0]];
    }
    
    // Traverse through the grid indices
    for (int row = 0; row < rowCount; row++) {
        for (int col = 0; col < columnCount; col++) {
            GameBoardTile *tile = [self retrieveTileAtRow:row column:col];
            
            
            // Increment the corresponding companyType index for every tile that has that companyType
            if (tile.companyType > 0) {
                int currentNumber = [chainNumbers[tile.companyType] intValue];
                currentNumber++;
                
                chainNumbers[tile.companyType] = [NSNumber numberWithInt:currentNumber];
                
            }
        }
        
        
    }
    
    
    return chainNumbers;
    
    
    
}


// Method to survey the board and return an array of the company types that exist on the board
// Returns the company types as integers and are sorted in ascending order
-(NSArray *)companyTypesOnBoard
{
    
    NSMutableArray *companyTypesArray = [[NSMutableArray alloc] init];
    
    
    // Traverse through grid
    for (int row = 0; row < rowCount; row++) {
        for (int col = 0; col < columnCount; col++) {
            
            GameBoardTile *tile = [self retrieveTileAtRow:row column:col];
            
            
            // Add company type at tile if not already added in companyTypesArray and if it exists
            if (tile.companyType > 0) {
                NSNumber *number = [NSNumber numberWithInt:tile.companyType];
                
                if (![companyTypesArray containsObject:number]) {
                    [companyTypesArray addObject:number];
                    
                }
            }
            
            
        }
        
        
    }
    
    
    // Sort the companyTypesArray
    [companyTypesArray sortUsingComparator:^(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;
        }
        
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
        
    }];
    
    return companyTypesArray;
    
    
}




#pragma mark PRIVATE


// Helper method to find the key (top, bottom, left, right) that returns the highest value given a dictionary of chain lengths
// Takes a dictionary of chain lengths as an argument
// Returns the key for the chain length with highest value
// If multiple keys have the same value, returns the most recently added key
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




// Finds the length of the longest contigous chain of the same company type
// starting at a specific row and column
// Takes as arguments a row and column value and returns a number specifying the chain amount
// Returns zero if the index is out of bounds or if there is no company existing at that tile
-(int)findLengthOfChainAtRow:(int)row column:(int)col
{
    NSMutableArray *previousTiles = [[NSMutableArray alloc] init];
    
    [self traverseChainAtRow:row column:col withPreviousTiles:previousTiles];
    
    return (int)[previousTiles count];
    
    

    
}




// Getter for the internal 2D array for the GameBoardTile objects grid
// Uses "lazy instantiation" to initialize the array
-(NSMutableArray *)tileRows
{
    if (!_tileRows) {
        _tileRows = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < rowCount; i++) {
            
            NSMutableArray *tileRow = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < columnCount; j++) {
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




// Function to find the length of the chains that exist at each surrounding tile
// Takes a GameBoardTile object as argument
// Returns a dictionary with key value pairs corresponding to top, bottom, left, and right
// counts of chain lengths for each position relative to the tile given
// Returns zeros for neighbors out of bounds
-(NSDictionary *)findLengthOfNeighbors:(GameBoardTile *)tile
{
    int row = tile.row;
    int col = tile.column;
    
    NSNumber *top, *bottom, *left, *right;
    
    
    
    // Find each individual chain length for surrounding locations of specified tile
    top = [NSNumber numberWithInt:[self findLengthOfChainAtRow:row-1 column:col]];
    
    bottom =[NSNumber numberWithInt:[self findLengthOfChainAtRow:row+1 column:col]];
    
    left = [NSNumber numberWithInt:[self findLengthOfChainAtRow:row column:col-1]];
    
    right = [NSNumber numberWithInt:[self findLengthOfChainAtRow:row column:col+1]];
    
    // Create dictionary using default keys
    NSDictionary *neighborLengths = @{topKey: top, bottomKey:bottom, leftKey :left, rightKey :right };
    
    
    return neighborLengths;
    
    
    
}




@end
