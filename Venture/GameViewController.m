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
#import "MarketTableViewController.h"



@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Game *game;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (strong, nonatomic) Grid *controlPanelGrid;
@property (strong, nonatomic) GameBoardTile *currentTileToBeChanged;
@property (strong, nonatomic) Grid *gameGrid;
@property (strong, nonatomic) Player *currentPlayer;
@property (strong, nonatomic) UILabel *playerLabel;
@property (strong, nonatomic) PortfolioView *portfolio;
@property (strong, nonatomic) MainMenuButton *marketButton;
@property (nonatomic) BOOL marketIsOpen;

//@property (strong, nonatomic) Grid *grid;

@property (nonatomic) double tileScaleFactor;


@end
@implementation GameViewController

const int playerCount = 4;


//const int tileCount = 108;
//const int placementTileCount = 6;





- (double)tileScaleFactor
{
    if (!_tileScaleFactor) {
        _tileScaleFactor = .9;
    }
    
    return _tileScaleFactor;
}


-(Game *)game
{
    if (!_game) {
        
        _game = [[Game alloc] initWithPlayerCount:playerCount];
        
    }
    return _game;
}

-(void) viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.translucent = NO;
    UIColor *color = self.view.backgroundColor;
    
    self.navigationController.navigationBar.barTintColor = color;
}

-(void)viewDidLoad
{
    UINavigationItem *navigation = self.navigationItem;
    
    CGRect frame = CGRectMake(0, 0, 100, 50);
    UILabel *ventureLabel = [[UILabel alloc] initWithFrame:frame];
    //ventureLabel.backgroundColor = [UIColor greenColor];
    
    UIFont *font = [UIFont fontWithName:@"optima-bold" size:25];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraph};
    
    NSAttributedString *ventureText = [[NSAttributedString alloc] initWithString:@"VENTURE" attributes:attributes];
    
    ventureLabel.attributedText = ventureText;
    
    navigation.titleView = ventureLabel;
    
    
    
    [self layoutTiles];
    [self updatePlayerLabel];
    
    [self updatePortfolioView];
    //[self setupMarketButton];
    
    

    
}

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

-(PortfolioView *)portfolio
{
    if (!_portfolio) {
        CGRect frame = self.controlPanelView.bounds;
        frame.size.height /=2;
        frame.origin.y += frame.size.height;
        
        _portfolio = [[PortfolioView alloc] initWithFrame:frame];
        
        _portfolio.cash = 0;
        _portfolio.stock = 0;
        _portfolio.majority = NO;
        
        [self.controlPanelView addSubview:_portfolio];
        
    }
    
    return _portfolio;
}


-(void)updatePortfolioView
{
    self.portfolio.cash = self.currentPlayer.cash;
    
    
    
    
}

-(void)updatePlayerLabel
{
    if (self.currentPlayer) {
        self.playerLabel.text = [NSString stringWithFormat:@"Player %d", [self.game.players indexOfObject:self.currentPlayer]+1];
    }
    else {
        self.playerLabel.text = @"Player";
    }
}


-(UILabel *)playerLabel
{
    if (!_playerLabel) {
        
        CGRect labelFrame = self.controlPanelView.bounds;
        
        labelFrame.size.height /= 4;
        labelFrame.size.width /= 2;
        
        
        
        
        _playerLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _playerLabel.center = CGPointMake(self.controlPanelView.frame.size.width/2, 3.0/4*self.controlPanelView.frame.size.height);
        
        //_playerLabel.backgroundColor = [UIColor orangeColor];
        if (self.currentPlayer) {
            _playerLabel.text = [NSString stringWithFormat:@"Player %d", [self.game.players indexOfObject:self.currentPlayer]+1];
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

-(void)viewDidAppear:(BOOL)animated
{
    
    [self updateMarks];
    
    [self updatePlaced];

    
}

-(Player *)currentPlayer
{
    if (!_currentPlayer) {
        
        NSArray *players = self.game.players;
        
        if (players) {
            
            _currentPlayer = players[0];
            
        }
        
        
    }
    
    return _currentPlayer;
}



-(void)updateMarks
{
    
    NSArray *stack = self.currentPlayer.placementTileStack;
    
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
    
    
    
    
    
    
    
}



-(void)sendCompanyTypeToModel:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        id view = gesture.view;
        if ([view isKindOfClass:[GameBoardTileView class]]) {
            GameBoardTileView *gameTileView = (GameBoardTileView *) view;
            int companyType = gameTileView.companyType;
            if (self.currentTileToBeChanged) {
                
                
                
                [self.game startCompanyAtTile:self.currentTileToBeChanged withCompanyType:[NSNumber numberWithInt:companyType] forPlayer:self.currentPlayer];
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
                
                 
            }
            
            
        }
        
        
    }
    
    self.marketIsOpen = YES;
}


-(void)chooseTileForMerger:(NSArray *)neighboringTiles
{
    for (GameBoardTile *tile in neighboringTiles) {
        
        NSMutableArray *previous = [[NSMutableArray alloc] init];
        [self.game.board findLengthOfChainAtRow:tile.row column:tile.column withPreviousTiles:previous];
        
        
        
        
        
        for (GameBoardTile *chainTile in previous) {
            
            GameBoardTileView *view = [self retrieveGameBoardTileViewAtRow:chainTile.row col:chainTile.column];
            
            //NSLog(@"row %d col %d", view.row, view.col);
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeMergerAction:)];
            
            [view addGestureRecognizer:gesture];
            
            view.userInteractionEnabled = YES;
            
            UIViewAnimationOptions options = UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve;
            
            
            [UIView transitionWithView:view duration:1 options:options animations:^{
                view.transform = CGAffineTransformMakeScale(1/self.tileScaleFactor, 1/self.tileScaleFactor);
                view.strokeColor = [UIColor whiteColor];
                view.lineWidth = 6;
                view.defaultAnimationMode = NO;
                [view setNeedsDisplay];
            }completion:^(BOOL finished) {
                
                if (finished) {
                    //NSLog(@"finished");
                }
                
                
                
                
            }];
//            [UIView animateWithDuration:1 delay:0 options:options animations:^{
//                
//                view.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                view.strokeColor = [UIColor whiteColor];
//                view.lineWidth = 10;
//                view.defaultAnimationMode = NO;
//                [view setNeedsDisplay];
//                
//                
//            } completion:nil];
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
}


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

-(void)completeMergerAction:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"tapped");
    
    [self stopAllAnimation];
    GameBoardTileView *view = (GameBoardTileView *) gesture.view;
    
    
    GameBoardTile *tile = [self.game.board retrieveTileAtRow:view.row column:view.col];
    
    [self.game completeMergerWithTile:tile];
    
    [self updatePlaced];
    
    
    
    [self toggleNextPlayer];
    self.marketIsOpen = YES;
    
}


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
    
    //[self performSelector:@selector(performMarketSegue) withObject:self afterDelay:1.5];
    
    
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"marketSegue"]) {
        
        UINavigationController *navigation = (UINavigationController *)segue.destinationViewController;
        
        if ([navigation.topViewController isKindOfClass:[MarketTableViewController class]]) {
            NSLog(@"%@", navigation.topViewController);
            MarketTableViewController *marketViewController = (MarketTableViewController *) navigation.topViewController;
            
            marketViewController.marketIsOpen = self.marketIsOpen;
            
            if (!marketViewController.game) {
                marketViewController.game = self.game;
            }
            
            
        }
    }
    
}


-(void)performMarketSegue
{
    [self performSegueWithIdentifier:@"marketSegue" sender:self.navigationItem.rightBarButtonItem];

}

-(void)nextPlayerButtonPressed:(id)sender
{
    self.marketIsOpen = NO;
    
    UIButton *button = (UIButton *)sender;
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        button.alpha = 0;
        button.center = CGPointMake(self.controlPanelView.frame.size.width/2, self.controlPanelView.frame.size.height+20+button.frame.size.height/2);
    }completion:^(BOOL finished) {
        if (finished) {
            [button removeFromSuperview];
            
            
            int playerIndex = [self.game.players indexOfObject:self.currentPlayer];
            
            if (playerIndex == [self.game.players count] -1) {
                self.currentPlayer = self.game.players[0];
            }
            else {
                self.currentPlayer = self.game.players[playerIndex+1];
            }
            
            [self eraseAllMarks];
            
            [self performSelector:@selector(flipPlayerView) withObject:self afterDelay:.25];
            
            
            
            
            //
            //    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{  self.view.alpha = 1.0;  } completion:nil];
            
            
        }
    }];
    
    [self toggleTaps:YES];
    
    self.game.market.purchaseCount = 0;
    
    
    
}

-(void)flipPlayerView
{
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        [self updatePlayerLabel];
        
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            [self updateMarks];
            
        }
    }];
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
                
                NSArray *neighboringTiles = [self.game chooseTileAtRow:row column:col forPlayer:self.currentPlayer];
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
               
                
                
                
                [self updateMarks];
                
                [gameTileView removeGestureRecognizer:[gameTileView.gestureRecognizers objectAtIndex:0]];
                
                self.marketIsOpen = abs([self.game.chainsInPlay count] - 8);
                
                
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
        _gameGrid.minimumNumberOfCells = self.game.tileBox.maxPlacementTiles;
        
    }
    
    return _gameGrid;
}


-(void)layoutTiles
{
    
    Grid *grid = self.gameGrid;
    
    
    for (int row = 0; row < [grid rowCount]; row++) {
        for (int col = 0; col < [grid columnCount]; col++) {
            if (row*[grid columnCount]+col < self.game.tileBox.maxPlacementTiles) {
                //NSLog(@"%d tile no", row*[grid columnCount]+col);
                
                CGRect frame = [grid frameOfCellAtRow:0 inColumn:0];
                frame.size = CGSizeMake(frame.size.width*self.tileScaleFactor, frame.size.height*self.tileScaleFactor);
                GameBoardTileView *tile = [[GameBoardTileView alloc] initWithFrame:frame];
                tile.defaultAnimationMode = YES;
                tile.center = [grid centerOfCellAtRow:row inColumn:col];
                tile.row = row;
                tile.col = col;
                //NSLog(@"tile center %f %f", tile.center.x, tile.center.y);
                
                [self.gameView addSubview:tile];
                
                
            }
        }
    }
    
    //NSLog(@"finished");
    
    
}













@end
