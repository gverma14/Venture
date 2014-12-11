//
//  TilePaletteView.m
//  Venture
//
//  Created by Gaurav Verma on 12/8/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "TilePaletteView.h"

@implementation TilePaletteView

-(instancetype)initWithFrame:(CGRect)frame chains:(NSArray *)chainsInPlay scaling:(double)tileScaleFactor activated:(BOOL)activated target:(id <TilePaletteViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    
    int totalButtonCount = [chainsInPlay count];
    
    CGRect tileFrame = self.bounds;
    tileFrame.size.width *= (tileScaleFactor/totalButtonCount);
    tileFrame.size.height = tileFrame.size.width;
    
    
    
    for (int i = 1; i<=totalButtonCount; i++) {
        GameBoardTileView *view = [[GameBoardTileView alloc] initWithFrame:tileFrame];
        view.companyType = [chainsInPlay[i-1] intValue];
        view.empty = NO;
        
        float centerX = frame.size.width/totalButtonCount/2 * (2* i -1);
        
        view.center = CGPointMake(centerX, frame.size.height/2);
        
        [self addSubview:view];
        
        if (activated) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(sendCompanyTypeToModel:)];
            [view addGestureRecognizer:tapGesture];

        }
        
        

        

        
        
        
    }
    
    return self;
    
    
    
    
    
    
}


@end

