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
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (strong, nonatomic) Grid *controlPanelGrid;
@property (strong, nonatomic) GameBoardTile *currentTileToBeChanged;
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

-(void)toggleTaps:(BOOL)activated{
    for (GameBoardTileView *view in self.gameView.subviews) {
        
        view.userInteractionEnabled = activated;
        
        
    }
    
}

-(void)chooseCompanyTypeWithChains:(NSArray *)chainsInPlay
{
    NSLog(@"%d chains in play", [chainsInPlay count]);
    
    CGRect frame = self.controlPanelView.bounds;
    frame.size.height /= 2;
    
    frame.origin.y = self.controlPanelView.bounds.size.height+20;
    
    UIView *selectionPalette = [[UIView alloc] initWithFrame:frame];
    
    //selectionPalette.backgroundColor = [UIColor orangeColor];
    
    [self.controlPanelView addSubview:selectionPalette];
    selectionPalette.alpha = 0;
    
    
    float buttonScaleFactor = .65;
    
    
    CGRect buttonFrame = CGRectMake(0, 0, selectionPalette.frame.size.height*buttonScaleFactor, selectionPalette.frame.size.height*buttonScaleFactor);
    
    int totalButtons = [chainsInPlay count];
    
    for (int i = 1; i <= totalButtons; i++) {
        GameBoardTileView *view = [[GameBoardTileView alloc] initWithFrame:buttonFrame];
        view.companyType = [chainsInPlay[i-1] intValue];
        view.empty = NO;
        
        
        NSLog(@"%d company type", view.companyType);
        
        
        float centerX = selectionPalette.frame.size.width/totalButtons/2*(2*i-1);
        //view.strokeColor = [UIColor orangeColor];
        view.center = CGPointMake(centerX, selectionPalette.frame.size.height/2);
        //view.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendCompanyTypeToModel:)];
        
        [view addGestureRecognizer:tapGesture];
        
        [selectionPalette addSubview:view];
    }
    
    [UIView animateWithDuration:.25 delay:.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGRect newFrame = selectionPalette.frame;
        newFrame.origin.y = 0;
        selectionPalette.frame = newFrame;
        
        selectionPalette.alpha = 1.0;
    
    
    } completion:nil];
    
    [self toggleTaps:NO];
    
    
    
    
}



-(void)sendCompanyTypeToModel:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        id view = gesture.view;
        if ([view isKindOfClass:[GameBoardTileView class]]) {
            GameBoardTileView *gameTileView = (GameBoardTileView *) view;
            int companyType = gameTileView.companyType;
            if (self.currentTileToBeChanged) {
                
                NSLog(@"Current company: %d New company %d", self.currentTileToBeChanged.companyType, companyType);
                
                [self.game startCompanyAtTile:self.currentTileToBeChanged withCompanyType:[NSNumber numberWithInt:companyType]];
                [self updatePlaced];
                self.currentTileToBeChanged = nil;
                
                
                [UIView animateWithDuration:.25 delay:.25 options:UIViewAnimationOptionLayoutSubviews animations:^ {
                    
                    CGRect newFrame = gameTileView.superview.frame;
                    
                    newFrame.origin.y = self.controlPanelView.frame.size.height+20;
                    gameTileView.superview.frame = newFrame;
                    
                    gameTileView.superview.alpha = 0.0;
                
                } completion:^(BOOL finished) {
                    
                    if (finished) {
                        [gameTileView.superview removeFromSuperview];
                    }
                }];
                
                [self toggleTaps:YES];
                 
            }
            
        }
        
    }
}


-(void)chooseTileForMerger:(NSArray *)neighboringTiles
{
    for (GameBoardTile *tile in neighboringTiles) {
        
        NSMutableArray *previous = [[NSMutableArray alloc] initWithObjects:tile, nil];
        [self.game.board findLengthOfChainAtRow:tile.row column:tile.column withPreviousTiles:previous];
        
        
        for (GameBoardTile *chainTile in previous) {
            
            GameBoardTileView *view = [self retrieveGameBoardTileViewAtRow:chainTile.row col:chainTile.column];
            
            NSLog(@"row %d col %d", view.row, view.col);
            //UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeMergerAction:)];
            
            //[view addGestureRecognizer:gesture];
            
            
        }
        
        
    }
    
    
}


-(void)completeMergerAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tapped");
    
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
                        
                        [self chooseTileForMerger:neighboringTiles];
                        
                        //[self.game completeMergerWithTile:changeTile fromTile:thisTile];
                        
                        
                    }
                    else if ([neighboringTiles count] == 1) {
                        //// need to pick color if the tile returned is the same as this tile
                        
                        GameBoardTile *neighboringTile = [neighboringTiles objectAtIndex:0];
                        
                        
                        if ([neighboringTile isEqual:thisTile]) {
                            /// need to pick color // user input here
                            
                            
                            
                            
                            
                            
                            /////////////////////
                            
                            
                            if ([self.game.chainsInPlay count]) {
                                
                                ///// choose color here
                                
                                NSArray *chainsInPlay = self.game.chainsInPlay;
                                self.currentTileToBeChanged = neighboringTile;
                                [self chooseCompanyTypeWithChains:chainsInPlay];
                                
                                
                                
                                
                                //[self.game startCompanyAtTile:thisTile withCompanyType:self.game.chainsInPlay[0]];
                                
                                
                                
                                
                                
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


-(Grid *)controlPanelGrid
{
    if (!_controlPanelGrid) {
        _controlPanelGrid = [[Grid alloc] init];
        _controlPanelGrid.size = self.controlPanelView.frame.size;
        _controlPanelGrid.cellAspectRatio = self.controlPanelView.frame.size.width/self.controlPanelView.frame.size.height;
        _controlPanelGrid.minimumNumberOfCells = 2;
    }
    
    return _controlPanelGrid;
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
