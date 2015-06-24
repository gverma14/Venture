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
#import "Player.h"
#import "MainMenuButton.h"
#import "PortfolioView.h"
#import "MarketViewController.h"
#import "TilePaletteView.h"
#import "PlacementTile.h"

@interface GameViewController () <TilePaletteViewDelegate, MarketViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Game *game;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (strong, nonatomic) Grid *controlPanelGrid;
@property (strong, nonatomic) GameBoardTile *currentTileToBeChanged;
@property (strong, nonatomic) Grid *gameGrid;

@property (strong, nonatomic) UILabel *playerLabel;
@property (strong, nonatomic) PortfolioView *portfolio;
@property (strong, nonatomic) MainMenuButton *marketButton;


//@property (strong, nonatomic) Grid *grid;

@property (nonatomic) double tileScaleFactor;



@end
@implementation GameViewController

const int playerCount = 4;
const double mergerHighlightFactor = 1.2;


#pragma mark - INITIAL SETUP
/////////////////////////

-(void)viewDidLoad
{
    [self setup];
    
    
}

// Initialize nav bar, layour game tiles, update player label, update portfolio view
-(void)setup
{
    [self setupNavigationBar];
    [self layoutTiles];
    [self updatePlayerLabel];
    [self updatePortfolioView];
}

// Set up markers and placed tiles after view appears
-(void)viewDidAppear:(BOOL)animated
{
    
    
    [self updateMarks];
    [self updatePlaced];
}

// Setup Navigation Bar that includes Venture Logo
-(void)setupNavigationBar
{
    UINavigationItem *navigation = self.navigationItem;
    
    CGRect frame = CGRectMake(0, 0, 100, 50);
    UILabel *ventureLabel = [[UILabel alloc] initWithFrame:frame];
    
    UIFont *font = [UIFont fontWithName:@"optima-bold" size:25];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraph};
    
    NSAttributedString *ventureText = [[NSAttributedString alloc] initWithString:@"VENTURE" attributes:attributes];
    
    ventureLabel.attributedText = ventureText;
    
    navigation.titleView = ventureLabel;
    self.navigationController.navigationBar.translucent = NO;
    UIColor *color = self.view.backgroundColor;
    self.navigationController.navigationBar.barTintColor = color;
    
}

// Layout gameboard tiles on game view
-(void)layoutTiles
{
    
    Grid *grid = self.gameGrid;
    
    
    for (int row = 0; row < [grid rowCount]; row++) {
        for (int col = 0; col < [grid columnCount]; col++) {
            if (row*[grid columnCount]+col < PlacementTileBox.maxPlacementTiles) {
                //NSLog(@"%d tile no", row*[grid columnCount]+col);
                
                CGRect frame = [grid frameOfCellAtRow:0 inColumn:0];
                frame.size = CGSizeMake(frame.size.width*self.tileScaleFactor, frame.size.height*self.tileScaleFactor);
                GameBoardTileView *tile = [[GameBoardTileView alloc] initWithFrame:frame];
                tile.defaultAnimationMode = YES;
                tile.center = [grid centerOfCellAtRow:row inColumn:col];
                tile.row = row;
                tile.col = col;
                
                [self.gameView addSubview:tile];
                
                
            }
        }
    }
    
    
    
}


////////////////////////////////////////





#pragma mark - STATUS UPDATES
////////////////

-(void)returnToBoard
{
    [self updatePortfolioView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Update the portfolio view onscreen
-(void)updatePortfolioView
{
    self.portfolio.cash = self.game.currentPlayer.cash;
    self.portfolio.stock = [self.game determineStockValue:self.game.currentPlayer];
    self.portfolio.majority = [self.game determineMajority:self.game.currentPlayer];
    
}

// update the current player label according to the model
-(void)updatePlayerLabel
{
    if (self.game.currentPlayer) {
        self.playerLabel.text = [NSString stringWithFormat:@"Player %d", (int)[self.game.players indexOfObject:self.game.currentPlayer]+1];
    }
    else {
        self.playerLabel.text = @"Player";
    }
}

-(void)updateMarks
{
    
    NSArray *stack = self.game.currentPlayer.placementTileStack;
    
    for (id obj in stack) {
        if ([obj isKindOfClass:[PlacementTile class]]) {
            PlacementTile *tile = (PlacementTile *)obj;
            int row = tile.row;
            int col = tile.col;
            
            
            
            GameBoardTileView *view = [self retrieveGameBoardTileViewAtRow:row col:col];
            
            
            
            if (!view.isMarked) {
                [self toggleGameTileAt:row col:col];
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
                
            }
            
            
            
             
            
        }
    }
    
}


-(void)eraseAllMarks
{
    for (GameBoardTileView *view in self.gameView.subviews) {
        
        if (view.isMarked) {
            [self toggleGameTileAt:view.row col:view.col];
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
                
                if (view.companyType != tile.companyType) {
                    view.companyType = tile.companyType;
                }
                
                
                
            }
            
            
            
        }
    }
    
}

-(void)toggleTaps:(BOOL)activated{
    for (GameBoardTileView *view in self.gameView.subviews) {
        
        view.userInteractionEnabled = activated;
        
        
    }
    
}


#pragma mark - CREATE COMPANY
//////////////////////////////////

// Adds a selection palette view to the screen and animates it
-(void)chooseCompanyTypeWithChains:(NSArray *)chainsInPlay
{
    
    CGRect frame = self.controlPanelView.bounds;
    frame.size.height /= 2;
    
    frame.origin.y = self.controlPanelView.bounds.size.height+20;
    
    
    TilePaletteView *selectionPalette = [[TilePaletteView alloc] initWithFrame:frame chains:self.game.chainsInPlay total:chainsPossible scaling:.9 activated:YES target:self multiRow:NO resizing:NO];
    
    
    
    [self.controlPanelView addSubview:selectionPalette];
    selectionPalette.alpha = 0;

    
    [UIView animateWithDuration:.25 delay:.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGRect newFrame = selectionPalette.frame;
        newFrame.origin.y = 0;
        selectionPalette.frame = newFrame;
        
        selectionPalette.alpha = 1.0;
    
    
    } completion:nil];
    
}


// Method that responds to tap from selection palette and changes model accordingly (in this case creates a new company)
-(void)sendCompanyTypeToModel:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        id view = gesture.view;
        if ([view isKindOfClass:[GameBoardTileView class]]) {
            GameBoardTileView *gameTileView = (GameBoardTileView *) view;
            int companyType = gameTileView.companyType;
            if (self.currentTileToBeChanged) {
                
                
                
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
                
                [self toggleNextPlayer];
                [self updatePortfolioView];
                 
            }
            
            
        }
        
        
    }
    
    
}






#pragma mark - EQUAL CHAIN MERGERS

// Activates highlighting animation for two chains of equal length.
// Needed for selection of merger
-(void)chooseTileForMerger:(NSArray *)neighboringTiles
{
    for (GameBoardTile *tile in neighboringTiles) {
        
        NSMutableArray *previous = [[NSMutableArray alloc] init];
        
        // Use to retrieve the tile objects in the chain
        //[self.game.board findLengthOfChainAtRow:tile.row column:tile.column withPreviousTiles:previous];
        [self.game.board traverseChainAtRow:tile.row column:tile.column withPreviousTiles:previous];
        
        
        
        
        
        for (GameBoardTile *chainTile in previous) {
            
            GameBoardTileView *view = [self retrieveGameBoardTileViewAtRow:chainTile.row col:chainTile.column];
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeMergerAction:)];
            
            [view addGestureRecognizer:gesture];
            
            view.userInteractionEnabled = YES;
            
            UIViewAnimationOptions options = UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve;
            
            
            [UIView transitionWithView:view duration:1 options:options animations:^{
                view.transform = CGAffineTransformMakeScale(mergerHighlightFactor, mergerHighlightFactor);
                view.strokeColor = [UIColor whiteColor];
                view.lineWidth = 6;
                view.defaultAnimationMode = NO;
                [view setNeedsDisplay];
            }completion:^(BOOL finished) {
                
                if (finished) {
                    //NSLog(@"finished");
                }
                
                
                
                
            }];

            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
}


// Action to be completed after a chain is selected to be the surviving chain
// Information is sent to the model and the view is then updated to reflect the new model status
-(void)completeMergerAction:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"tapped");
    
    [self stopAllAnimation];
    GameBoardTileView *view = (GameBoardTileView *) gesture.view;
    
    
    GameBoardTile *tile = [self.game.board retrieveTileAtRow:view.row column:view.col];
    
    [self.game completeMergerWithTile:tile];
    
    [self updatePlaced];
    
    
    [self updatePortfolioView];
    [self toggleNextPlayer];
    
    
}




// Returns highlighting tiles back to normal static state
-(void)stopAllAnimation
{
    for (GameBoardTileView *view in self.gameView.subviews) {
        
        
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            
            
            view.transform = CGAffineTransformIdentity;
            
            if (!view.defaultAnimationMode) {
                view.defaultAnimationMode = YES;
                view.strokeColor = [UIColor clearColor];
                view.lineWidth = 3;
                [view setNeedsDisplay];
            }
        
        
        
        } completion:^(BOOL finished){
                if (finished) {
                    [view.layer removeAllAnimations];
                    
                }
            
            }];
        
        
        
    }
    
    
}


#pragma mark - END OF TURN
// Animates the on screen view of the next player button
-(void)toggleNextPlayer
{
    CGRect controlFrame = self.controlPanelView.bounds;
    
    CGSize buttonSize = CGSizeMake(controlFrame.size.width/2, controlFrame.size.height/4);
    
    CGRect buttonFrame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    
    
    MainMenuButton *button = [[MainMenuButton alloc] initWithFrame:buttonFrame];
    
    
    [button setTitle:@"End Turn" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(nextPlayerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    button.alpha = 0;
    button.center = CGPointMake(controlFrame.size.width/2, controlFrame.size.height+20+button.frame.size.height/2);
    
    [self.controlPanelView addSubview:button];
    
    [UIView animateWithDuration:.25 delay:.75 options:UIViewAnimationOptionLayoutSubviews animations:^{
        button.alpha = 1.0;
        button.center = CGPointMake(controlFrame.size.width/2, controlFrame.size.height/4);
        
    }completion:nil];
    //NSLog(@"activating button");
    
    [self toggleTaps:NO];
    
    
    [self checkMarkers];
    
    
    
    
}


// Action to be completed when next player button pressed
// calls for model to be updated
-(void)nextPlayerButtonPressed:(id)sender
{
    
    
    
    
    UIButton *button = (UIButton *)sender;
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        button.alpha = 0;
        button.center = CGPointMake(self.controlPanelView.frame.size.width/2, self.controlPanelView.frame.size.height+20+button.frame.size.height/2);
    }completion:^(BOOL finished) {
        if (finished) {
            [button removeFromSuperview];
            
            [self.game completePlayerTurn];
            
            
            
            [self eraseAllMarks];
            
            [self performSelector:@selector(flipPlayerView) withObject:self afterDelay:.25];
            
            
            
            
            
        }
    }];
    
    [self toggleTaps:YES];
        
    
    
}

// flips the player view when the turn is over
// activates the animations and updates the player label to reflect current status
-(void)flipPlayerView
{
    [UIView transitionWithView:self.view duration:.25 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        [self updatePlayerLabel];
        [self updatePortfolioView];
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            
            
            
            
            //NSArray *placementTilesRemoved = [self.game checkMarkers];
            [self updateMarks];
            
            
            
            
            
        }
    }];
}



-(void)checkMarkers
{
    NSArray *placementTilesRemoved = [self.game checkMarkers];
    
    for(PlacementTile *tile in placementTilesRemoved) {
        int row = tile.row;
        int column = tile.col;
        
        
        [self toggleGameTileAt:row col:column];
        
        GameBoardTileView *view = [self retrieveGameBoardTileViewAtRow:row col:column];
        [view removeGestureRecognizer:view.gestureRecognizers[0]];
        
        
        
    }
    
//    if ([placementTilesRemoved count]) {
//        [self updateMarks];
//    }
    
}










#pragma mark - GAMEBOARD
/////////////////////////////////


// Registers a game play tile tap on the game board
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
                    
                    if ([neighboringTiles count] > 1) {
                        //// need to pick merger
                        
                        
                        ////// Pick which tile you are changing here, default right now is first tile
                        [self toggleTaps:NO];
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
                                
                                [self toggleTaps:NO];
                                [self chooseCompanyTypeWithChains:chainsInPlay];
                                
                                
                                
                                
                                //[self.game startCompanyAtTile:thisTile withCompanyType:self.game.chainsInPlay[0]];
                                
                                
                                
                                
                                
                            }
                            else {
                                
                                thisTile.companyType = 0;
                                [self toggleNextPlayer];
                            }
                            
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                }
                else {
                    
                    [self toggleNextPlayer];
                }
               
                
                
                
                //[self updateMarks];
                
                [gameTileView removeGestureRecognizer:[gameTileView.gestureRecognizers objectAtIndex:0]];
                
                [self.game endOfTurn];
                
                
            }
            
            
            [self updatePlaced];
            
            
            
        }
    }
}

// Retrieves the specific game tile view among the gameview's subviews using row and column notation
-(GameBoardTileView *)retrieveGameBoardTileViewAtRow:(int)rowIndex col:(int)colIndex
{
    int gridIndex = rowIndex*(int)self.gameGrid.columnCount+colIndex;
    
    GameBoardTileView *view = [[self. gameView subviews] objectAtIndex:gridIndex];
    return view;
    
}

// If a game tile is marked, it toggles the game tile to be unmarked and filled with color (white if no company type)
// If a game tile is colored (white if no company type), it toggles the game tile to be marked
-(void)toggleGameTileAt:(int)rowIndex col:(int)colIndex
{
    
    
    TileView *view = [self retrieveGameBoardTileViewAtRow:rowIndex col:colIndex];
    
    view.marked = !view.marked;
    view.empty = view.marked;
    

}






#pragma mark - MARKET
//////////////////////////

// Sends relevant information to the Market View Controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"marketSegue"]) {
        
        UINavigationController *navigation = (UINavigationController *)segue.destinationViewController;
        
        if ([navigation.topViewController isKindOfClass:[MarketViewController class]]) {
            MarketViewController *marketViewController = (MarketViewController *) navigation.topViewController;
                        
            if (!marketViewController.game) {
                marketViewController.game = self.game;
                marketViewController.delegate = self;
            }
            
            
        }
    }
    
}




#pragma mark - GETTERS
///////////////////////////////

/// Return game grid for game view
-(Grid *)gameGrid
{
    if (!_gameGrid) {
        _gameGrid = [[Grid alloc] init];
        _gameGrid.size = self.gameView.frame.size;
        _gameGrid.cellAspectRatio = 1;
        _gameGrid.minimumNumberOfCells = PlacementTileBox.maxPlacementTiles;
        
    }
    
    return _gameGrid;
}




// Returns portfolio view currently on screen, creates default view of all zeroes if nonexistent
-(PortfolioView *)portfolio
{
    if (!_portfolio) {
        CGRect frame = self.controlPanelView.bounds;
        frame.size.height /=2;
        frame.origin.y += frame.size.height;
        
        _portfolio = [[PortfolioView alloc] initWithFrame:frame];
        
        _portfolio.cash = self.game.currentPlayer.cash;
        _portfolio.stock = [self.game determineStockValue:self.game.currentPlayer];
        _portfolio.majority = [self.game determineMajority:self.game.currentPlayer];
        
        [self.controlPanelView addSubview:_portfolio];
        
    }
    
    return _portfolio;
}


// Returns the player name label that appears on screen, creates one if nonexistent
-(UILabel *)playerLabel
{
    if (!_playerLabel) {
        
        CGRect labelFrame = self.controlPanelView.bounds;
        
        labelFrame.size.height /= 4;
        labelFrame.size.width /= 2;
        
        
        
        
        _playerLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _playerLabel.center = CGPointMake(self.controlPanelView.frame.size.width/2, 3.0/4*self.controlPanelView.frame.size.height);
        
        if (self.game.currentPlayer) {
            _playerLabel.text = [NSString stringWithFormat:@"Player %d", (int)[self.game.players indexOfObject:self.game.currentPlayer]+1];
        }
        else {
            _playerLabel.text = @"Player";
        }
        _playerLabel.textAlignment = NSTextAlignmentCenter;
        _playerLabel.textColor = [UIColor whiteColor];
        
        [self.controlPanelView addSubview:_playerLabel];
        
        
        
    }
    
    return _playerLabel;
}

// Initializes game object with player count constant
-(Game *)game
{
    if (!_game) {
        
        _game = [[Game alloc] initWithPlayerCount:playerCount];
        
    }
    return _game;
}



// Scale factor for drawing tiles within the game grid to adjust the spacing between each other
- (double)tileScaleFactor
{
    if (!_tileScaleFactor) {
        _tileScaleFactor = .9;
    }
    
    return _tileScaleFactor;
}


#pragma mark - UNUSED
/////////////////////////////////


-(void)setupMarketButton
{
    [self.marketButton setTitle:@"Market" forState:UIControlStateNormal];
    [self.marketButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(MainMenuButton *)marketButton
{
    if (!_marketButton) {
        
        CGRect frame = self.controlPanelView.bounds;
        frame.size = CGSizeMake(frame.size.height/1.5, frame.size.height/4);
        frame.origin.x = self.controlPanelView.frame.size.width - frame.size.width;
        
        _marketButton = [[MainMenuButton alloc] initWithFrame:frame];
        
        _marketButton.center = CGPointMake(_marketButton.center.x, self.controlPanelView.frame.size.height*3.0/4);
        [self.controlPanelView addSubview:_marketButton];
        [_marketButton addTarget:self action:@selector(goToMarketScreen:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _marketButton;
}

-(void)goToMarketScreen:(id)sender
{
    //NSLog(@"tapped");
    
}

// Return the grid for the control panel view
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


-(void)performMarketSegue
{
    [self performSegueWithIdentifier:@"marketSegue" sender:self.navigationItem.rightBarButtonItem];
    
}








@end
