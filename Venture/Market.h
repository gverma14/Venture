//
//  Market.h
//  Venture
//
//  Created by Gaurav Verma on 11/20/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Market : NSObject

-(NSArray *)sharePrices:(NSArray *)sharesPlayed;

@property (nonatomic, strong) NSMutableArray *sharesLeft;
@property (nonatomic) int numberOfCompanies;
@property (nonatomic) int purchaseCount;
@property (nonatomic, getter = isOpen) BOOL open;


-(instancetype)initWithNumberCompanies:(int)number;



@end
