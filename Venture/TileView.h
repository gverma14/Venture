//
//  TileView.h
//  Venture
//
//  Created by Gaurav Verma on 10/23/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileView : UIView



@property (nonatomic, getter = isEmpty) BOOL empty;
@property (nonatomic, getter = isMarked) BOOL marked;

@property (nonatomic, strong) NSString *marker;
@property (nonatomic) int lineWidth;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *emptyFillColor;
@property (nonatomic, strong) UIColor *emptyStrokeColor;
@property (nonatomic) BOOL defaultAnimationMode;
- (void)drawMarker;
-(void)addContents;
-(void)saveContext;

- (void)popContext;



@end

const double markerScaleFactor;
