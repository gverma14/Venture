//
//  MarketTableViewController.m
//  Venture
//
//  Created by Gaurav Verma on 12/6/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "MarketTableViewController.h"

@interface MarketTableViewController ()


@property (nonatomic) int purchaseCount;



@end


@implementation MarketTableViewController


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) viewDidLoad
{
    
    self.navigationController.navigationBar.translucent = NO;
    UIColor *color = self.view.backgroundColor;
    
    
    
    self.navigationController.navigationBar.barTintColor = color;
    self.tableView.scrollEnabled = NO;
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshControl];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (self.players && self.market && section == 0 ){
        
        return [self.players count]+2;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell" forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row > 0) {
            
            
            
            
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
            NSString *nameString;
            
            if (indexPath.row > [self.players count]) {
                nameString = @"Bank";
            }
            else {
                nameString = [NSString stringWithFormat:@"%d", indexPath.row];
            }
            
            NSDictionary *attributes = [nameLabel.attributedText attributesAtIndex:0 effectiveRange:nil];
            
            
            nameLabel.attributedText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
            NSArray *sharesOwned;
            if (indexPath.row <= [self.players count]) {
                Player *player = self.players[indexPath.row -1];
                sharesOwned = player.sharesOwned;
            }
            else {
                sharesOwned = self.market.sharesLeft;
            }
            
            
            for (int i = 1; i <= 7; i++) {
                
                UILabel *shareLabel = (UILabel *)[cell viewWithTag:i];
                
                NSNumber *shares = (NSNumber *) sharesOwned[i];
                
                NSString *shareString = [NSString stringWithFormat:@"%d", shares.intValue];
                
                
                shareLabel.attributedText = [[NSAttributedString alloc] initWithString:shareString attributes:attributes];
                
            }
            
            
            
            
            
            
            
            
            
        }
    }
    else {
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
        NSDictionary *attributes = [nameLabel.attributedText attributesAtIndex:0 effectiveRange:nil];
        nameLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Buy" attributes:attributes];
        
        for (int i = 1; i <= 7; i++) {
            
            UILabel *view = (UILabel *) [cell viewWithTag:i];
            
            
            NSArray *sharesLeft = self.market.sharesLeft;
            int bankShareNumber = [sharesLeft[i] intValue];
            
            BOOL found = NO;
            
            for (NSNumber *number in self.chainsInPlay) {
                
                if ([number intValue] == i) {
                    found = YES;
                    break;
                }
                
            }
            
            
            NSLog(@"%d", found);
            
            if (view) {
                [view removeFromSuperview];

                if (bankShareNumber && !found) {
                    CGRect frame = view.frame;
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame = frame;
                    [button setAttributedTitle:view.attributedText forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(addShare:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:button];
                    
                    
                    if (self.market.purchaseCount == 3) {
                        button.enabled = NO;
                    }
                    else {
                        button.enabled = self.marketIsOpen;
                    }
                    
                    
                }
            }
            
        }
    }
    
    
    return cell;
}

-(void)addShare:(UIButton *)sender
{
    
    int company = [[[sender attributedTitleForState:UIControlStateNormal] string] intValue];
    
    NSMutableArray *sharesLeft = self.market.sharesLeft;
    int bankShareNumber = [sharesLeft[company] intValue];
    
    if (bankShareNumber > 0) {
        bankShareNumber--;
        
        
        NSMutableArray *sharesOwned = self.currentPlayer.sharesOwned;
        int playerShareNumber = [sharesOwned[company] intValue];
        playerShareNumber++;
        
        
        
        self.market.purchaseCount++;
        
        sharesLeft[company] = [NSNumber numberWithInt:bankShareNumber];
        sharesOwned[company] = [NSNumber numberWithInt:playerShareNumber];
        
    
        

    }
    
    if (bankShareNumber == 0) {
        [sender removeFromSuperview];
    }
    
    
    
    
    
    
    
    
    

    
    NSLog(@"%@", [[sender attributedTitleForState:UIControlStateNormal] string]);
    
    if (self.market.purchaseCount == 3) {
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
