//
//  MarketViewController.m
//  Venture
//
//  Created by Gaurav Verma on 12/18/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "MarketViewController.h"
#import "TilePaletteView.h"
#import "MarketTableViewController.h"

@interface MarketViewController () <TilePaletteViewDelegate>

@property (strong, nonatomic) MarketTableViewController *table;
@property (strong, nonatomic) TilePaletteView *palette;
@property (nonatomic) CGPoint offScreenCenter;
@property (nonatomic) CGPoint paletteCenter;
@property (nonatomic) CGRect paletteFrame;



@end

static const double paletteTileScaling = .9;


@implementation MarketViewController


-(void)viewDidLoad
{
    [self setupNavBar];
    self.table.game = self.game;
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setupPurchaseBar];
}



-(TilePaletteView *)palette
{
    if (!_palette) {
        CGRect frame = CGRectMake(0, 0, 300, 50);
        self.paletteFrame = frame;
        TilePaletteView *view = [[TilePaletteView alloc] initWithFrame:frame chains:[self.game.board companyTypesOnBoard] total:chainsPossible scaling:paletteTileScaling activated:YES target:self multiRow:YES resizing:NO];
        
        CGRect windowFrame = self.view.frame;
        CGPoint windowCenter = self.view.center;
        CGPoint paletteCenter = CGPointMake(windowCenter.x, windowFrame.size.height-20-view.frame.size.height/2);
        CGPoint offScreenCenter = CGPointMake(windowCenter.x, windowFrame.size.height+frame.size.height/2);
        
        self.offScreenCenter = offScreenCenter;
        self.paletteCenter = paletteCenter;
        
        view.center = offScreenCenter;
        view.alpha = 0;
        
        [self.view addSubview:view];
        _palette = view;
        
    }
    
    return _palette;
}



-(void)setupPurchaseBar
{
    if (self.game.market.isOpen) {
        
        TilePaletteView *view = self.palette;
        
        
        
        [UIView animateWithDuration:.25 animations:^{
            
            view.alpha = 1;
            view.center = self.paletteCenter;
        } completion:nil];
        
        
        
        
        
        
        
    }
}

-(MarketTableViewController *) table
{
    if (!_table) {
        
        _table = self.childViewControllers[0];
        
    }
    return _table;
}


-(void)setupNavBar
{
    self.navigationController.navigationBar.translucent = NO;
    UIColor *color = self.view.backgroundColor;
    
    
    
    self.navigationController.navigationBar.barTintColor = color;
    
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
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)sendCompanyTypeToModel:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    
    if ([view isKindOfClass:[GameBoardTileView class]]) {
        
        GameBoardTileView *tile = (GameBoardTileView *)view;
        
        int companyType = tile.companyType;
        [self.game addShare:companyType];
        
        NSArray *sharesLeft = self.game.market.sharesLeft;
        int bankShareNumber = [sharesLeft[companyType] intValue];
        
        if(bankShareNumber == 0) {
            TilePaletteView *oldPalette = self.palette;
            
            [UIView animateWithDuration:.25 animations:^{
                oldPalette.alpha = 0;
                oldPalette.center = self.offScreenCenter;
                
                
                
            }completion:^(BOOL finished) {
                if (finished) {
                    
                    [oldPalette removeFromSuperview];
                    
                    NSMutableArray *chains = [[self.game.board companyTypesOnBoard] mutableCopy];
                    NSNumber *companyNumber = [NSNumber numberWithInt:companyType];
                    
                    [chains removeObject:companyNumber];
                    
                    TilePaletteView *newPalette = [[TilePaletteView alloc] initWithFrame:self.paletteFrame chains:chains total:chainsPossible scaling:paletteTileScaling activated:YES target:self multiRow:YES resizing:NO];
                    newPalette.center = self.offScreenCenter;
                    newPalette.alpha = 0;
                    
                    [self.view addSubview: newPalette];
                    
                    [UIView animateWithDuration:.25 animations:^{
                        newPalette.alpha = 1;
                        newPalette.center = self.paletteCenter;
                    }completion:^(BOOL finished) {
                        if (finished) {
                            NSLog(@"finished");
                        }
                    }];
                    
                    
                }
            }];
            
            
            
    
        }
        
        
        UITableView *table = self.table.tableView;
        NSMutableArray *indices = [[NSMutableArray alloc] init];
        
        for (int section = 0; section < [table numberOfSections]; section++){
            for (int row = 0; row < [table numberOfRowsInSection:section]; row++){
                if (!(row == 0 && section == 0)) {
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
                    [indices addObject:index];

                    
                }
                
                
                
                
            }
        }
        
        [table reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationNone];
        
        
        
        
        
    }
    
    
    
}
//
//-(void)addShare:(UIButton *)sender
//{
//    
//    int companyType = [[[sender attributedTitleForState:UIControlStateNormal] string] intValue];
//    
//    
//    [self.game addShare:(companyType)];
//    
//    
//    
//    
//    NSArray *sharesLeft = self.game.market.sharesLeft;
//    int bankShareNumber = [sharesLeft[companyType] intValue];
//    
//    if (bankShareNumber == 0) {
//        [sender removeFromSuperview];
//    }
//    
//    
//    if (self.game.market.purchaseCount == 3) {
//        UIView *superview = sender.superview;
//        
//        for (UIView *subview in superview.subviews) {
//            
//            if ([subview isKindOfClass:[UIButton class]]) {
//                UIButton *button = (UIButton *)subview;
//                button.enabled = NO;
//            }
//        }
//    }
//    
//    
//    //[self.tableView reloadData];
//    
//    
//}


@end
