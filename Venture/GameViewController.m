//
//  GameViewController.m
//  Venture
//
//  Created by Gaurav Verma on 10/23/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "GameViewController.h"
#import "Grid.h"

#import "Game.h"
#import "PlacementTile.h"
#import "GameBoardTileView.h"
#import "GameBoardTile.h"



@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Game *game;

@property (strong, nonatomic) Grid *gameGrid;
//@property (strong, nonatomic) Grid *grid;

@property (nonatomic) double tileScaleFactor;


@end
@implementation GameViewController



//const int tileCount = 108;
//const int placementTileCount = 6;


-(Game *)game
{
    if (!_game) {
        _game = [[Game alloc] init];
        
    }
    
    return _game;
}




- (double)tileScaleFactor
{
    if (!_tileScaleFactor) {
        _tileScaleFactor = .9;
    }
    
    return _tileScaleFactor;
}


-(void)viewDidLoad
{

    [self layoutTiles];
    
    //[self layoutPlacementTiles];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self updateMarks];
    
    [self updatePlaced];
    
}



-(void)updateMarks
{
    NSArray *stack = self.game.placementTileStack;
    for (id obj in stack) {
        if ([obj isKindOfClass:[PlacementTile class]]) {
            PlacementTile *tile = (PlacementTile *)obj;
            int row = tile.row;
            int col = tile.col;
            
            
            
            GameBoardTileView *view = [self retrieveGameBoardTileViewAtRow:row col:col];
            //[view addGestureRecognizer: [UITapGestureRecognizer alloc] initwit  ]
            
            
            
            if (!view.isMarked) {
                [self toggleGameTileAt:row col:col];
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
                
            }
            
            
            
             
            
        }
    }
    
}

-(void)updatePlaced
{
    NSArray *views = self.gameView.subviews;
    
    
    for (int row = 0; row < self.game.numberRows; row++) {
        for (int col = 0; col < self.game.numberColumns; col++) {
            GameBoardTile *tile = [self.game.board retrieveTileAtRow:row column:col];
            
            int index = row*self.game.numberColumns+col;
            
            if (index < [views count]) {
                GameBoardTileView *view = [views objectAtIndex:index];
                
                if (tile.companyType > 0) {
                    //NSLog(@"row:%d col:%d", row, col);
                    
                }
                if (view.companyType != tile.companyType) {
                    view.companyType = tile.companyType;
                }
                
                //NSLog(@"%d index", index);
            }
            
            
            
        }
    }
    
}


-(void)tap:(UITapGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded) {
        id view = gesture.view;
        if ([view isKindOfClass:[GameBoardTileView class]]) {
            GameBoardTileView *gameTileView = (GameBoardTileView *) view;
            int row = gameTileView.row;
            int col = gameTileView.col;
            
            [self toggleGameTileAt:row col:col];
            
            if (!gameTileView.isMarked) {
                
                NSArray *neighboringTiles = [self.game chooseTileAtRow:row column:col];
                GameBoardTile *thisTile = [self.game.board retrieveTileAtRow:row column:col];
                
                if (neighboringTiles) {
                    NSMutableArray *changedCompanyTiles = [[NSMutableArray alloc] init];
                    
                    if ([neighboringTiles count] > 1) {
                        //// need to pick merger
                        
                        
                        ////// Pick which tile you are changing here, default right now is first tile
                        GameBoardTile *changeTile = neighboringTiles[0];
                        
                        [self.game completeMergerWithTile:changeTile fromTile:thisTile];
                        
                        
                    }
                    else if ([neighboringTiles count] == 1) {
                        //// need to pick color if the tile returned is the same as this tile
                        
                        GameBoardTile *neighboringTile = [neighboringTiles objectAtIndex:0];
                        
                        
                        if ([neighboringTile isEqual:thisTile]) {
                            /// need to pick color // user input here
                            
                            
                            
                            
                            
                            
                            /////////////////////
                            
                            
                            if ([self.game.chainsInPlay count]) {
                                
                                ///// choose color here
                                
                                
                                [self.game startCompanyAtTile:thisTile withCompanyType:self.game.chainsInPlay[0]];
                                
                                
                                
                                
                                
                            }
                            else {
                                
                                thisTile.companyType = 0;
                            }
                            
                            
                            
                            
                            
                        }
                        
                    }
                    
                    for (id obj in changedCompanyTiles) {
                        
                        int company = [obj intValue];
                        
                        NSLog(@"Changed company %d", company);
                        
                        
                    }
                    
                    
                    
                    
                    
                }
               
                
                
                
                [self updateMarks];
                
                [gameTileView removeGestureRecognizer:[gameTileView.gestureRecognizers objectAtIndex:0]];
                
            }
            
            
            [self updatePlaced];
            
        }
    }
}






-(GameBoardTileView *)retrieveGameBoardTileViewAtRow:(int)rowIndex col:(int)colIndex
{
    int gridIndex = rowIndex*self.gameGrid.columnCount+colIndex;
    
    GameBoardTileView *view = [[self. gameView subviews] objectAtIndex:gridIndex];
    return view;
    
}

-(void)toggleGameTileAt:(int)rowIndex col:(int)colIndex
{
    
    
    TileView *view = [self retrieveGameBoardTileViewAtRow:rowIndex col:colIndex];
    
    view.marked = !view.marked;
    view.empty = view.marked;
    

}




-(Grid *)gameGrid
{
    if (!_gameGrid) {
        _gameGrid = [[Grid alloc] init];
        _gameGrid.size = self.gameView.frame.size;
        _gameGrid.cellAspectRatio = 1;
        _gameGrid.minimumNumberOfCells = self.game.tileCount;
        
    }
    
    return _gameGrid;
}


-(void)layoutTiles
{
    
    Grid *grid = self.gameGrid;
    
    for (int row = 0; row < [grid rowCount]; row++) {
        for (int col = 0; col < [grid columnCount]; col++) {
            if (row*[grid columnCount]+col < self.game.tileCount) {
                CGRect frame = [grid frameOfCellAtRow:0 inColumn:0];
                frame.size = CGSizeMake(frame.size.width*self.tileScaleFactor, frame.size.height*self.tileScaleFactor);
                GameBoardTileView *tile = [[GameBoardTileView alloc] initWithFrame:frame];
                tile.center = [grid centerOfCellAtRow:row inColumn:col];
                tile.row = row;
                tile.col = col;
                //NSLog(@"tile center %f %f", tile.center.x, tile.center.y);
                
                [self.gameView addSubview:tile];
                
                
            }
        }
    }
    
    
}













@end
