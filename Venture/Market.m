//
//  Market.m
//  Venture
//
//  Created by Gaurav Verma on 11/20/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "Market.h"

@implementation Market


-(instancetype)initWithNumberCompanies:(int)number
{
    self = [super init];
    
    self.numberOfCompanies = number;
    
    return self;
    
}


-(NSMutableArray *)sharePrices
{
    if (!_sharePrices) {
        _sharePrices = [[NSMutableArray alloc] initWithCapacity:self.numberOfCompanies+1];
        NSNumber *number = [NSNumber numberWithInt:0];
        [_sharePrices addObject:number];
        
        for (int i = 1; i <= self.numberOfCompanies; i++) {
            NSNumber *number = [NSNumber numberWithInt:0];
            [_sharePrices setObject:number atIndexedSubscript:i];
            
            
        }
        //NSLog(@"share price count %d", [_sharePrices count]);
        
        
    }
    return _sharePrices;
}


-(NSMutableArray *)sharesLeft
{
    if (!_sharesLeft) {
        _sharesLeft = [[NSMutableArray alloc] initWithCapacity:self.numberOfCompanies+1];
        
        NSNumber *number = [NSNumber numberWithInt:0];
        [_sharesLeft addObject:number];
        
        for (int i = 1; i <= self.numberOfCompanies; i++) {
            NSNumber *number = [NSNumber numberWithInt:25];
            [_sharesLeft addObject:number];
            
        }
        
        
        
    }
    return _sharesLeft;
}

@end
