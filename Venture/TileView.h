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

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *emptyFillColor;
@property (nonatomic, strong) UIColor *emptyStrokeColor;
- (void)drawMarker;
-(void)addContents;
-(void)saveContext;

- (void)popContext;



@end

const double markerScaleFactor;
