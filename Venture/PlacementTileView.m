//
//  PlacementTileView.m
//  Venture
//
//  Created by Gaurav Verma on 10/28/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "PlacementTileView.h"

@implementation PlacementTileView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.col = 1;
    return self;
}

@synthesize row = _row;
-(NSString *)row
{
    if (!_row) {
        _row = @"";
        
    }
    return _row;
}



-(UIColor *)emptyFillColor
{
    return [UIColor clearColor];
}

-(UIColor *)emptyStrokeColor
{
    return [UIColor whiteColor];
}


-(void)setRow:(NSString *)row
{
    _row = row;
    
    [self setNeedsDisplay];
}

-(void)setCol:(int)col
{
    _col = col;
    [self setNeedsDisplay];
}

-(NSString *)marker
{
    NSString *str = [NSString stringWithFormat:@"%@%d", self.row, self.col];
    return str;
    
}




@end
