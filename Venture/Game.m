//
//  Game.m
//  Venture
//
//  Created by Gaurav Verma on 10/30/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "Game.h"


@interface Game()




@end





@implementation Game

-(instancetype)initWithPlayerCount:(int)nPlayers
{
    self = [super init];

    for (int i = 0 ; i < nPlayers; i++) {
        Player *player = [[Player alloc] initWithCompanies:chainsPossible tileBox:self.tileBox];
        [self.players addObject:player];
    }
    
    return self;
    
}


-(NSMutableArray *)players
{
    if (!_players) {
        _players =  [[NSMutableArray alloc] init];
        
    }
    return _players;
    
}

-(Market *)market
{
    if (!_market) {
        _market = [[Market alloc] initWithNumberCompanies:chainsPossible];
    }
    return _market;
}

-(NSMutableArray *)chainsInPlay
{
    if (!_chainsInPlay) {
        _chainsInPlay = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= chainsPossible; i++) {
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



///// Returns nil if there are all empty tiles neighboring
///// Returns array of neighboring tiles if merger is needed
///// Returns array of one tile if there is only one highest chain tile
///// Returns array of the same tile if there are only neutral tiles surrounding and a color is needed

-(NSArray *)chooseTileAtRow:(int)row column:(int)col forPlayer:(Player *)player
{
    
    
    
    PlacementTile *oldPlacementTile = nil;
    
    //Finds the matching placement tile at the recently selected gameboard tile
    for (PlacementTile *placementTile in player.placementTileStack) {
        
        if (row == placementTile.row && col == placementTile.col) {
            oldPlacementTile = placementTile;
            break;
        }
        
        
    }
    
    
    // check if the current placement tile exists
    if (oldPlacementTile) {
         
         
        
//        int index = [player.placementTileStack indexOfObject:oldPlacementTile];
//        
//        
//        
//         //Checks if the placement tile exists at that row col selected and draws a new placement tile
//        if ([player.placementTileStack objectAtIndex:index]) {
//            
//            //// replace placement tile at that index for the player
//            
////            [player.placementTileStack removeObjectAtIndex:index];
////            PlacementTile *newPlacementTile = [self.tileBox drawRandomTile];
////            if (newPlacementTile) {
////                [self.placementTileStack insertObject:newPlacementTile atIndex:index];
////            }
//        }
        
        
        /// replaces players placement tile
        [player replacePlacementTile:oldPlacementTile fromTileBox:self.tileBox];
        
        
        
        /////////////////////////////////////////////////////
        
        // Retrieves the game tile at the spot just selected
        GameBoardTile *tile = [self.board retrieveTileAtRow:row column:col];
        
         
         // Makes sure the spot is empty THIS IS JUST A SECONDARY CHECK
        if (tile.companyType == -1) {
        
            NSArray *highestNeighboringTiles = [self.board findHighestNeighboringTiles:tile];
            
            tile.companyType = 0;
            
            //NSLog(@"%d neighboring tile count", [highestNeighboringTiles count]);
            
            // makes sure there is only one highest chain and makes all the other tiles merged into that
            if ([highestNeighboringTiles count] == 1) {
                
                NSMutableArray *changedCompanyTiles = [[NSMutableArray alloc] init];
                
                for (GameBoardTile *neighboringTile in highestNeighboringTiles) {
                    if (neighboringTile.companyType != 0) {
                        NSMutableArray *previousTiles = [[NSMutableArray alloc] initWithObjects:tile, nil];
                        
                        tile.companyType = neighboringTile.companyType;
                        
                        [self.board changeNeighborsOfTile:tile toCompanyType:tile.companyType withPreviousTiles:previousTiles withChangedCompanyTiles:changedCompanyTiles];
                        
                        
                        
                    }
                }
                
                [self.chainsInPlay addObjectsFromArray:changedCompanyTiles];
                
                //NSLog(@"%d changed companies", [changedCompanyTiles count]);
            }
            else if ( [highestNeighboringTiles count] > 1) {
                return highestNeighboringTiles;
            }
            else {
                NSArray *neighbors = [self.board getNeighboringTiles:tile];
                
                for (GameBoardTile *neighborTile in neighbors) {
                    
                    if (neighborTile.companyType == 0) {
                        return [NSArray arrayWithObject:tile];
                    }
                    
                    
                }
                
            }
            
            // Returns an array of the highest neighboring tiles
            // 0 count if there are no highest neighboring tiles, no change needed
            //
            // 2 or more neighboring tiles for mergers, each company type should be checked and user input needed for selecting the color, if all neighbors zero new company
            
            
        }
        
        
    }
    
    
    return nil;
    
}



-(void)completeMergerWithTile:(GameBoardTile *)mergerTile
{
    
    
    NSMutableArray *previous = [[NSMutableArray alloc]initWithObjects:mergerTile, nil];
    NSMutableArray *changedCompanies = [[NSMutableArray alloc] init];
    
    
    [self.board changeNeighborsOfTile:mergerTile toCompanyType:mergerTile.companyType withPreviousTiles:previous withChangedCompanyTiles:changedCompanies];
    
    
    
    [self.chainsInPlay addObjectsFromArray:changedCompanies];
    //NSLog(@"%d chains in play", [self.chainsInPlay count]);
    
}


-(void)startCompanyAtTile:(GameBoardTile *)tile withCompanyType:(NSNumber *)companyType forPlayer:(Player *)player
{
    NSMutableArray *previous = [[NSMutableArray alloc] initWithObjects:tile, nil];
    NSMutableArray *changedCompanies = [[NSMutableArray alloc] init];
    
    tile.companyType = [companyType intValue];
    
    [self.board changeNeighborsOfTile:tile toCompanyType:[companyType intValue] withPreviousTiles:previous withChangedCompanyTiles:changedCompanies];
    
    [self.chainsInPlay removeObjectIdenticalTo:companyType];
    
    NSMutableArray *sharesOwned = player.sharesOwned;
    NSMutableArray *sharesLeft = self.market.sharesLeft;
    

    int playerShareNumber = [[sharesOwned objectAtIndex:[companyType intValue]] intValue];
    int bankShareNumber = [[sharesLeft objectAtIndex:[companyType intValue]] intValue];
    
    playerShareNumber++;
    bankShareNumber--;
    
    
    [sharesOwned setObject:[NSNumber numberWithInt:playerShareNumber] atIndexedSubscript:[companyType intValue]];
    [sharesLeft setObject:[NSNumber numberWithInt:bankShareNumber] atIndexedSubscript:[companyType intValue]];
    
    

    
    
    
    
    
    
}


-(int) generateRandomNumber:(int)begin end:(int) end {
    
    return arc4random()%(end+1 - begin) +begin;
    
}


-(NSArray *)determinePrices
{
    NSArray *chain = [self.board chainNumbersOnBoard:chainsPossible];
    
    NSArray *sharePrices = [self.market sharePrices:chain];
    return sharePrices;
    

    
}







//
//-(NSMutableArray *)placementTileStack
//{
//    if (!_placementTileStack) {
//        _placementTileStack = [[NSMutableArray alloc] init];
//
//
//        for (int i = 0 ; i < self.placementTileCount; i++) {
//            PlacementTile *placementTile = [self.tileBox drawRandomTile];
//
//            [_placementTileStack addObject:placementTile];
//
//        }
//
//
//    }
//
//
//    return _placementTileStack;
//}







@end
