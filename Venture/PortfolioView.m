//
//  PortfolioView.m
//  Venture
//
//  Created by Gaurav Verma on 11/22/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "PortfolioView.h"

@interface PortfolioView ()

@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UILabel *cashLabel;
@property (strong, nonatomic) UILabel *stockLabel;
@property (strong, nonatomic) UILabel *majorityLabel;


@end

@implementation PortfolioView

-(UILabel *)cashLabel
{
    
    if (!_cashLabel) {
        
        CGRect frame = self.bounds;
        frame.size.height /= 4;
        
        _cashLabel = [[UILabel alloc] initWithFrame:frame];
        _cashLabel.text = [NSString stringWithFormat:@"Cash: %d", self.cash];
        _cashLabel.textColor = [UIColor whiteColor];
//        _cashLabel.adjustsFontSizeToFitWidth = YES;
//        _cashLabel.minimumScaleFactor = .001;
        UIFont *font = _cashLabel.font;
        font = [font fontWithSize:font.pointSize*.75];
        _cashLabel.font = font;
        [self addSubview:_cashLabel];
        
    }
    return _cashLabel;
}

-(UILabel *)stockLabel
{
    if (!_stockLabel) {
        CGRect frame = self.bounds;
        frame.size.height /= 4;
        frame.origin.y += frame.size.height;
        
        _stockLabel = [[UILabel alloc] initWithFrame:frame];
        _stockLabel.text = [NSString stringWithFormat:@"Stock: %d", self.stock];
        _stockLabel.textColor = [UIColor whiteColor];
        UIFont *font = _stockLabel.font;
        font = [font fontWithSize:font.pointSize*.75];
        _stockLabel.font = font;
//        _stockLabel.adjustsFontSizeToFitWidth = YES;
//        _stockLabel.minimumScaleFactor = .001;
        [self addSubview:_stockLabel];
    }
    return _stockLabel;
}

-(UILabel *)totalLabel
{
    if (!_totalLabel) {
        CGRect frame = self.bounds;
        frame.size.height /= 4;
        frame.origin.y += 2*frame.size.height;
        
        _totalLabel = [[UILabel alloc] initWithFrame:frame];
        _totalLabel.text = [NSString stringWithFormat:@"Total: %d", self.stock+self.cash];
        _totalLabel.textColor = [UIColor whiteColor];
//        _totalLabel.adjustsFontSizeToFitWidth = YES;
//        _totalLabel.minimumScaleFactor = .001;
        UIFont *font = _totalLabel.font;
        font = [font fontWithSize:font.pointSize*.75];
        _totalLabel.font = font;
        [self addSubview:_totalLabel];
        
    }
    
    return _totalLabel;
}

-(UILabel *)majorityLabel
{
    if (!_majorityLabel) {
        CGRect frame = self.bounds;
        frame.size.height /= 4;
        frame.origin.y += 3*frame.size.height;
        
        _majorityLabel = [[UILabel alloc] initWithFrame:frame];
        NSString *majority = self.majority ? @"YES" : @"NO";
        
        _majorityLabel.text = [NSString stringWithFormat:@"Majority %@", majority];
        _majorityLabel.textColor = [UIColor whiteColor];
//        _majorityLabel.adjustsFontSizeToFitWidth = YES;
//        _majorityLabel.minimumScaleFactor = .001;
        
        UIFont *font = _majorityLabel.font;
        font = [font fontWithSize:font.pointSize*.75];
        _majorityLabel.font = font;
        [self addSubview:_majorityLabel];
    }
    
    
    return _majorityLabel;
}


//////////////////

-(void)setCash:(int)cash
{
    _cash = cash;
    self.cashLabel.text = [NSString stringWithFormat:@"Cash: %d", cash];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: %d", cash + self.stock];
}

-(void)setStock:(int)stock
{
    _stock = stock;
    self.stockLabel.text = [NSString stringWithFormat:@"Stock: %d", stock];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: %d", stock + self.cash];
    
}

-(void)setMajority:(BOOL)majority
{
    _majority = majority;
    NSString *majorityText = majority ? @"YES" : @"NO";
    
    
    self.majorityLabel.text = [NSString stringWithFormat:@"Majority: %@", majorityText];
    
}







@end
