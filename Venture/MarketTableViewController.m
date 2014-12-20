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




- (void) viewDidLoad
{
    self.tableView.scrollEnabled = NO;

    
    
    NSLog(@"Market Open:%d", self.game.market.isOpen);
    
    if (self.game) {
        NSLog(@"exists");
    }
    NSLog(@"%@ self", self);
    NSLog(@"%@ parent controller", self.parentViewController);
    
    //self.tableView.backgroundColor = [UIColor grayColor];
}






-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0 ){
        
        return [self.game.players count]+2;
    }
    return 1;
}



-(void)sendCompanyTypeToModel:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tapped");
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell" forIndexPath:indexPath];
    UIView *labelView = [cell viewWithTag:100];
    UIView *infoView = [cell viewWithTag:101];
    

    

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
            BOOL currentPlayer = NO;
            
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
                
                if ([thisPlayer isEqual:self.game.currentPlayer]) {
                    currentPlayer = YES;
                }
                sharesOwned = thisPlayer.sharesOwned;
                
                nameLabel.text = nameString;
                priceLabel.text = priceString;
                
                
                
            }
            
            
            /// Fill name and price label
            
            
            
            
            

            
            
            
            
            for (int i = 1; i <= chainsPossible; i++) {
                UILabel *label = (UILabel *) infoView.subviews[i-1];
                NSNumber *shares =  sharesOwned[i];
                
                NSString *shareString = [NSString stringWithFormat:@"%d", [shares intValue]];
                
                if(currentPlayer && [shares intValue]) {
                    label.highlighted = YES;
                    
                    label.highlightedTextColor = [UIColor greenColor];
                }
                
                label.text = shareString;
                
            }
            
            
            
            
            
            
            
            
            
            
            
        }
        else {
            //infoView.backgroundColor = [UIColor whiteColor] ;
            
            
            CGRect frame = infoView.bounds;
            
            
            
            TilePaletteView *paletteView = [[TilePaletteView alloc] initWithFrame:frame chains:[Game createInitialChainArray:chainsPossible] total:chainsPossible scaling:.9 activated:NO target:nil multiRow:NO resizing:NO];
            
            
            
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
    
        

    }
    
    
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell"];
    
    if (indexPath.section == 2) {
        
        return cell.frame.size.height*1.1;
        
        
        
    }
    
    return cell.frame.size.height;
    
    
}









@end
