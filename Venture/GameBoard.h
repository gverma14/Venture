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

@property (strong, nonatomic) NSMutableArray *tileRows;
@property (nonatomic) int rowCount;
@property (nonatomic) int colCount;



-(GameBoardTile *)retrieveTileAtRow:(int)row column:(int)col;

-(NSArray *)getNeighboringTiles:(GameBoardTile *)tile;
-(NSArray *)findHighestNeighboringTiles:(GameBoardTile *)tile;
-(void)changeNeighborsOfTile:(GameBoardTile *)tile toCompanyType:(int)companyType withPreviousTiles:(NSMutableArray *)previousTiles withChangedCompanyTiles:(NSMutableArray *)changedCompanyTiles;
-(int)findLengthOfChainAtRow:(int)row column:(int)col withPreviousTiles:(NSMutableArray *)previousTiles;

@end
