//
//  TilePaletteView.h
//  Venture
//
//  Created by Gaurav Verma on 12/8/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBoardTileView.h"


@protocol TilePaletteViewDelegate

-(void)sendCompanyTypeToModel:(UITapGestureRecognizer *)gesture;

@end




@interface TilePaletteView : UIView

-(instancetype)initWithFrame:(CGRect)frame chains:(NSArray *)chainsInPlay scaling:(double)tileScaleFactor activated:(BOOL)activated target:(id <TilePaletteViewDelegate>)delegate;



@end
