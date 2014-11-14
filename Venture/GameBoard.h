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
//-(instancetype)initWith:(int)rowCount columnCount:(int)colCount;
//
-(NSArray *)getNeighboringTilesAtRow:(int)row column:(int)col;
-(NSDictionary *)findLengthOfNeighborsAtRow:(int)row column:(int)col;
-(void)changeNeighborsAtRow:(int)row column:(int)column toCompanyType:(int)companyType withPreviousTiles:(NSMutableArray *)previousTiles;


-(GameBoardTile *)retrieveTileAtRow:(int)row column:(int)col;

@end
