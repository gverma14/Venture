//
//  Game.h
//  Venture
//
//  Created by Gaurav Verma on 10/30/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoardTile.h"
#import "GameBoard.h"

@interface Game : NSObject

@property (strong, nonatomic) NSMutableArray *placementTileStack;
@property (nonatomic) int tileCount;
- (void)replaceTileAtIndex:(int)index;
@property (nonatomic) int placementTileCount;
@property (nonatomic) int tilesPlayed;
-(NSArray *) chooseTileAtRow:(int)row column:(int)col; ///Returns an array of the highest chain length neighboring tiles

-(void)completeMergerWithTile:(GameBoardTile *)mergerTile;
-(void)startCompanyAtTile:(GameBoardTile *)tile withCompanyType:(NSNumber *)companyType;

@property (strong, nonatomic) GameBoard *board;
@property (nonatomic) int numberRows;
@property (nonatomic) int numberColumns;
@property (strong, nonatomic) NSMutableArray *chainsInPlay;

@end



