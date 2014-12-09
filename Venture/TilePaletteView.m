//
//  TilePaletteView.m
//  Venture
//
//  Created by Gaurav Verma on 12/8/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "TilePaletteView.h"

@implementation TilePaletteView

-(instancetype)initWithFrame:(CGRect)frame chains:(int)chainsPossible
{
    self = [super initWithFrame:frame];
    
    CGRect tileFrame = self.bounds;
    tileFrame.size.width *= (.9/chainsPossible);
    tileFrame.size.height = tileFrame.size.width;
    
    for (int i = 1; i<=chainsPossible; i++) {
        GameBoardTileView *view = [[GameBoardTileView alloc] initWithFrame:tileFrame];
        view.companyType = i;
        view.empty = NO;
        
        float centerX = frame.size.width/chainsPossible/2 * (2* i -1);
        
        view.center = CGPointMake(centerX, frame.size.height/2);
        
        [self addSubview:view];
        
        

        
        
        
    }
    
    return self;
    
    
    
    
    
    
}


@end

