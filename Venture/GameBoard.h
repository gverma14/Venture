//
//  GameBoard.h
//  Venture
//
//  Created by Gaurav Verma on 11/7/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoardTile.h"


@interface GameBoard : NSObject


// Class values
+ (int) rowCount;
+ (int) colCount;


// Survey the GameBoard
-(NSArray *)companyTypesOnBoard;
-(NSArray *)chainNumbersOnBoard:(int)totalCompanies;


// Access GameBoardTile objects on GameBoard
-(GameBoardTile *)retrieveTileAtRow:(int)row column:(int)col;
-(NSArray *)getNeighboringTiles:(GameBoardTile *)tile;
-(NSArray *)findNeighboringTilesOf:(GameBoardTile *)tile greaterThan:(int)chainLength;
-(NSArray *)findHighestNeighboringTiles:(GameBoardTile *)tile;


// Methods for dealing with chains
-(void)changeNeighborsOfTile:(GameBoardTile *)tile
               toCompanyType:(int)companyType
           withPreviousTiles:(NSMutableArray *)previousTiles
     withChangedCompanyTiles:(NSMutableArray *)changedCompanyTiles;

-(void)traverseChainAtRow:(int)row
                   column:(int)col
        withPreviousTiles:(NSMutableArray *)previousTiles;




@end
