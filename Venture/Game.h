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
#import "Player.h"
#import "Market.h"
#import "PlacementTile.h"
#import "PlacementTileBox.h"

@interface Game : NSObject


-(instancetype)initWithPlayerCount:(int)nPlayers;

// Tile Box properties
@property (strong, nonatomic) PlacementTileBox *tileBox;

/// Game board actions
-(void)completeMergerWithTile:(GameBoardTile *)mergerTile;
-(void)startCompanyAtTile:(GameBoardTile *)tile withCompanyType:(NSNumber *)companyType forPlayer:(Player *)player;
-(NSArray *) chooseTileAtRow:(int)row column:(int)col forPlayer:(Player *)player; ///Returns an array of the highest chain length neighboring tiles



// Game board properties
@property (strong, nonatomic) GameBoard *board;
@property (nonatomic) int numberRows;
@property (nonatomic) int numberColumns;
@property (strong, nonatomic) NSMutableArray *chainsInPlay;
@property (nonatomic) int tilesPlayed;


// Gameplay properties
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) Market *market;


@end

static const int chainsPossible = 7;







