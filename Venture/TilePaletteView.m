//
//  TilePaletteView.m
//  Venture
//
//  Created by Gaurav Verma on 12/8/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "TilePaletteView.h"
#import "Grid.h"

@implementation TilePaletteView

-(instancetype)initWithFrame:(CGRect)frame chains:(NSArray *)chainsInPlay total:(int)chainsPossible scaling:(double)tileScaleFactor activated:(BOOL)activated target:(id <TilePaletteViewDelegate>)delegate multiRow:(BOOL)multiLeveled resizing:(BOOL)resizeActivated
{
    
    CGRect initialFrame = frame;
    
    if (multiLeveled) {
        initialFrame.size.height *= 2;
    }
    
    
    
    
    self = [super initWithFrame:initialFrame];
    
    //self.backgroundColor = [UIColor grayColor];
    
    int totalButtonCount = [chainsInPlay count];
    
    NSLog(@"%d button count", totalButtonCount);
    
    CGRect tileFrame = self.bounds;
    
    int resizeScale = chainsPossible;
    
    if (resizeActivated) {
        resizeScale = totalButtonCount;
    }
    
    // Specifies the width of each individual button in the palette
    tileFrame.size.width *= (tileScaleFactor/resizeScale);
    tileFrame.size.height = tileFrame.size.width;
    
    if (tileFrame.size.height > (frame.size.height * tileScaleFactor)) {
        tileFrame.size.width = frame.size.height *tileScaleFactor;
        tileFrame.size.height = frame.size.height*tileScaleFactor;
    }
    
    
    double midPoint = (totalButtonCount+1)/2.0;
    BOOL buttonOnTop = YES; //Button starts on top
    
    
    
    
    for (int i = 1; i<=totalButtonCount; i++) {
        
        GameBoardTileView *view = [[GameBoardTileView alloc] initWithFrame:tileFrame];
        view.companyType = [chainsInPlay[i-1] intValue];
        view.empty = NO;
        
        float centerX = frame.size.width/totalButtonCount/2 * (2* i -1);
        float centerY = initialFrame.size.height/2;
        if (multiLeveled) {
            
            if (buttonOnTop) {
                centerY = initialFrame.size.height/4;

            }
            else {
                centerY = initialFrame.size.height*3.0/4;
            }
            
            if ( ((i+1) <= midPoint) || i >= midPoint) {
                buttonOnTop = !buttonOnTop;
            }
        }
        
        
        
        view.center = CGPointMake(centerX, centerY);
        
        [self addSubview:view];
        
        if (activated) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(sendCompanyTypeToModel:)];
            [view addGestureRecognizer:tapGesture];

        }
        
        

        

        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    return self;
    
    
    
    
    
    
}


@end


