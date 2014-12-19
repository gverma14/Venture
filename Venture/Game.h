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
-(void)startCompanyAtTile:(GameBoardTile *)tile withCompanyType:(NSNumber *)companyType;
-(NSArray *) chooseTileAtRow:(int)row column:(int)col; ///Returns an array of the highest chain length neighboring tiles



// Game board properties
@property (strong, nonatomic) GameBoard *board;
@property (nonatomic) int numberRows;
@property (nonatomic) int numberColumns;
@property (strong, nonatomic) NSMutableArray *chainsInPlay;
@property (nonatomic) int tilesPlayed;

-(void)addShare:(int)companyType;

-(void)endOfTurn;

-(NSArray *)determinePrices;

-(void)restoreChains:(NSArray *)changedCompanyTiles;


// Gameplay properties
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) Market *market;

/// Retrieve current player defaults to first player in players array if none is set
@property (nonatomic, strong) Player *currentPlayer;

-(void)completePlayerTurn;


+(NSMutableArray *)createInitialChainArray:(int)numberOfCompanies;

@end

static const int chainsPossible = 7;







