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


-(NSArray *)sharePrices:(NSArray *)sharesPlayed
{
    NSMutableArray *sharePrices = [[NSMutableArray alloc] init];
    [sharePrices addObject:[NSNumber numberWithInt:0]];
    
    for (int i = 1; i <= self.numberOfCompanies; i++) {
        [sharePrices addObject:[NSNumber numberWithInt:0]];
    }
    
    
    
    for (int i = 1; i <= self.numberOfCompanies; i++) {
        
        int shareNumber = [sharesPlayed[i] intValue];
        int sharePrice = 0;
        
        if (shareNumber > 0) {
            
            if (shareNumber >=  6) {
                switch (i) {
                    case 1:
                        sharePrice = (shareNumber-1)/10+6;
                        break;
                    case 2:
                        sharePrice = (shareNumber-1)/10+6;
                        break;
                    case 3:
                        sharePrice = (shareNumber-1)/10+7;
                        break;
                    case 4:
                        sharePrice = (shareNumber-1)/10+7;
                        break;
                    case 5:
                        sharePrice = (shareNumber-1)/10+7;
                        break;
                    case 6:
                        sharePrice = (shareNumber-1)/10+8;
                        break;
                    case 7:
                        sharePrice = (shareNumber-1)/10+8;
                        break;
                        
                    default:
                        break;
                }
            }
            else {
                switch (i) {
                    case 1:
                        sharePrice = shareNumber;
                        break;
                    case 2:
                        sharePrice = shareNumber;
                        break;
                    case 3:
                        sharePrice = shareNumber + 1;
                        break;
                    case 4:
                        sharePrice = shareNumber +1;
                        break;
                    case 5:
                        sharePrice = shareNumber+1;
                        break;
                    case 6:
                        sharePrice = shareNumber+2;
                        break;
                    case 7:
                        sharePrice = shareNumber+2;
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            
            
        
            sharePrices[i] = [NSNumber numberWithInt:sharePrice];
        
        
        }
        
        
        
        
    }
    
    return sharePrices;
    
    
    
    
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
