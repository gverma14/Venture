//
//  MarketTableViewController.m
//  Venture
//
//  Created by Gaurav Verma on 12/6/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "MarketTableViewController.h"
#import "GameBoard.h"
#import "GameBoardTileView.h"
#import "TilePaletteView.h"

@interface MarketTableViewController ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;





@end


@implementation MarketTableViewController


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) viewDidLoad
{
    self.tableView.scrollEnabled = NO;

    [self setupNavBar];
    
    
    
    
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



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0 ){
        
        return [self.game.players count]+2;
    }
    
    return 1;
}
- (IBAction)testPress:(UIBarButtonItem *)sender {
    
    [self.tableView reloadData];
    
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell" forIndexPath:indexPath];
    UIView *labelView = [cell viewWithTag:100];
    UIView *infoView = [cell viewWithTag:101];
    
//    if (indexPath.section == 1) {
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:labelView.bounds];
//        label.backgroundColor = [UIColor greenColor];
//        label.backgroundColor = [label.backgroundColor colorWithAlphaComponent:.5];
//        
//        [labelView addSubview:label];
//        
//    }
    //NSLog(@"new table");


    //NSLog(@"labelview count %d", [labelView.subviews count]);
    
    

    if (indexPath.section == 0) {
        if (indexPath.row > 0) {
            
            
            
            
            // Set up name label and price label
            if (![labelView.subviews count]) {
                if (indexPath.row > [self.game.players count]) {
                    UILabel *label = [[UILabel alloc] initWithFrame:labelView.bounds];
                    label.text = @"X";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor whiteColor];
                    [labelView addSubview:label];
                    
                }
                else {
                    CGRect frame = labelView.bounds;
                    frame.size.width /= 2;
                    
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
                    
                    frame.origin.x += frame.size.width;
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:frame];
                    
                    //nameLabel.backgroundColor = [UIColor greenColor];
                    //priceLabel.backgroundColor = [UIColor redColor];
                    
                    //nameLabel.backgroundColor = [nameLabel.backgroundColor colorWithAlphaComponent:.5];
                    //priceLabel.backgroundColor = [priceLabel.backgroundColor colorWithAlphaComponent:.5];
                    
                    nameLabel.textAlignment = NSTextAlignmentCenter;
                    priceLabel.textAlignment = NSTextAlignmentCenter;
                    
                    nameLabel.textColor = [UIColor whiteColor];
                    priceLabel.textColor = [UIColor whiteColor];
                    
                    nameLabel.text = @"X";
                    priceLabel.text = @"X";
                    
                    
                    [labelView addSubview:nameLabel];
                    [labelView addSubview:priceLabel];

                }
                
                
                
            }
            
            
            // Set up company share number labels
            if (![infoView.subviews count]) {
                CGRect frame = infoView.bounds;
                frame.size.width /= chainsPossible;
                
                for (int i = 1; i <= chainsPossible; i++) {
                    
                    
                    UILabel *shareLabel = [[UILabel alloc] initWithFrame:frame];
                    
                    //shareLabel.backgroundColor = [UIColor yellowColor];
                    //shareLabel.backgroundColor = [shareLabel.backgroundColor colorWithAlphaComponent:.5];
                    shareLabel.text = @"X";
                    shareLabel.textAlignment = NSTextAlignmentCenter;
                    shareLabel.textColor = [UIColor whiteColor];
                    [infoView addSubview:shareLabel];
                    
                    frame.origin.x += frame.size.width;
                    
                    
                }
            }
            
            
            NSArray *sharesOwned;

            
            if ([labelView.subviews count] == 1) {
                UILabel *label = labelView.subviews[0];
                label.text = @"Bank";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                sharesOwned = self.game.market.sharesLeft;
            }
            else if ([labelView.subviews count] == 2) {
                UILabel *nameLabel = labelView.subviews[0];
                UILabel *priceLabel = labelView.subviews[1];
                
                NSString *nameString = [NSString stringWithFormat:@"%d", indexPath.row];;
                
                Player *thisPlayer = self.game.players[indexPath.row-1];
                NSString *priceString = [NSString stringWithFormat:@"$%d", thisPlayer.cash];
                
                sharesOwned = thisPlayer.sharesOwned;
                
                nameLabel.text = nameString;
                priceLabel.text = priceString;
                
                
                
            }
            
            
            /// Fill name and price label
            
            
            
            
            

            
            
            
            
            for (int i = 1; i <= chainsPossible; i++) {
                UILabel *label = (UILabel *) infoView.subviews[i-1];
                NSNumber *shares =  sharesOwned[i];
                
                NSString *shareString = [NSString stringWithFormat:@"%d", [shares intValue]];
                
                label.text = shareString;
                
            }
            
            
            
            
            
            
            
            
            
            
            
        }
        else {
            //infoView.backgroundColor = [UIColor whiteColor] ;
            CGRect frame = infoView.bounds;
            
            
            
            TilePaletteView *paletteView = [[TilePaletteView alloc] initWithFrame:frame chains:[Game createInitialChainArray:chainsPossible] scaling:.85  activated:NO target:nil];
            
            
            [infoView addSubview:paletteView];
            
            
            
        }
    }
    
    
    
    
    else if (indexPath.section == 1) {
        
        NSArray *sharePrices = [self.game determinePrices];

        
        if (![labelView.subviews count]) {
            UILabel *label = [[UILabel alloc] initWithFrame:labelView.bounds];
            label.text = @"Price";
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [labelView addSubview:label];
            
        }
        
        if (![infoView.subviews count]) {
            
            CGRect frame = infoView.bounds;
            frame.size.width /= chainsPossible;
            
            for (int i = 1; i <= chainsPossible; i++) {
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:frame];
                priceLabel.text = @"X";
                priceLabel.textAlignment = NSTextAlignmentCenter;
                priceLabel.textColor = [UIColor whiteColor];
                [infoView addSubview:priceLabel];
                frame.origin.x += frame.size.width;
            }
            
        }
        
        
        
        for (int i = 1; i <= chainsPossible; i++) {
            UILabel *label = infoView.subviews[i-1];
            
            int sharePrice = [sharePrices[i] intValue];
            if (sharePrice == 0) {
                label.text = @"-";
            }
            else {
                label.text = @"$";
                label.text = [label.text stringByAppendingString:[sharePrices[i] stringValue]];

            }
            
            
        }
        
        
        
        
        
        
        
        
        
        
//        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
//        NSDictionary *attributes = [nameLabel.attributedText attributesAtIndex:0 effectiveRange:nil];
//        nameLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Buy" attributes:attributes];
//        
//        for (int i = 1; i <= 7; i++) {
//            
//            UILabel *view = (UILabel *) [cell viewWithTag:i];
//            
//            
//            NSArray *sharesLeft = self.game.market.sharesLeft;
//            int bankShareNumber = [sharesLeft[i] intValue];
//            
//            BOOL found = NO;
//            
//            for (NSNumber *number in self.game.chainsInPlay) {
//                
//                if ([number intValue] == i) {
//                    found = YES;
//                    break;
//                }
//                
//            }
//            
//            
//            //NSLog(@"%d", found);
//            
//            if (view) {
//                [view removeFromSuperview];
//
//                if (bankShareNumber && !found) {
//                    CGRect frame = view.frame;
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//                    button.frame = frame;
//                    [button setAttributedTitle:view.attributedText forState:UIControlStateNormal];
//                    [button addTarget:self action:@selector(addShare:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell addSubview:button];
//                    
//                    
//                    if (self.game.market.purchaseCount == 3) {
//                        button.enabled = NO;
//                    }
//                    else {
//                        button.enabled = self.marketIsOpen;
//                    }
//                    
//                    
//                }
//            }
//            
//        }
    }
    
    
    return cell;
}

-(void)addShare:(UIButton *)sender
{
    
    int company = [[[sender attributedTitleForState:UIControlStateNormal] string] intValue];
    
    NSMutableArray *sharesLeft = self.game.market.sharesLeft;
    int bankShareNumber = [sharesLeft[company] intValue];
    
    if (bankShareNumber > 0) {
        bankShareNumber--;
        
        
        NSMutableArray *sharesOwned = self.currentPlayer.sharesOwned;
        int playerShareNumber = [sharesOwned[company] intValue];
        playerShareNumber++;
        
        
        
        self.game.market.purchaseCount++;
        
        sharesLeft[company] = [NSNumber numberWithInt:bankShareNumber];
        sharesOwned[company] = [NSNumber numberWithInt:playerShareNumber];
        
    
        

    }
    
    if (bankShareNumber == 0) {
        [sender removeFromSuperview];
    }
    
    
    
    
    
    
    
    
    

    
    //NSLog(@"%@", [[sender attributedTitleForState:UIControlStateNormal] string]);
    
    if (self.game.market.purchaseCount == 3) {
        UIView *superview = sender.superview;
        
        for (UIView *subview in superview.subviews) {
            
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                button.enabled = NO;
            }
        }
    }
    
    
    [self.tableView reloadData];
    
    
}






@end
