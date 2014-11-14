//
//  TileView.m
//  Venture
//
//  Created by Gaurav Verma on 10/23/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "TileView.h"

const double markerScaleFactor =.65; //  points height per pointSize



@implementation TileView

-(UIColor *)fillColor
{
    if (!_fillColor) {
        _fillColor = [UIColor colorWithRed:240.0/255 green:220.0/255 blue:210.0/255 alpha:1];
        
    }
    return _fillColor;
}

-(UIColor *)strokeColor
{
    if (!_strokeColor) {
        _strokeColor = [UIColor clearColor];
    }
    return _strokeColor;
}

-(UIColor *)emptyFillColor
{
    if (!_emptyFillColor)
    {
        _emptyFillColor = [UIColor whiteColor];
    }
    return _emptyFillColor;
}

-(UIColor *)emptyStrokeColor
{
    if (!_emptyStrokeColor) {
        _emptyStrokeColor = [UIColor clearColor];
    }
    
    return _emptyStrokeColor;
}

@synthesize marker = _marker;

-(void)setMarker:(NSString *)marker
{
    _marker = marker;
    
    
    [self setNeedsDisplay];
    
}


- (NSString *)marker
{
    if (!_marker) {
        _marker = @"X";
        
        
        
        //NSLog(@"X");
    }
    
    return _marker;
}


-(void)setMarked:(BOOL)marked
{
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t) 5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{ _marked = marked; NSLog(@"%d marked", _marked);});
    _marked =marked;
    
    //_marked = marked;
    
    //[self performSelector:@selector(setNeedsDisplay:) withObject:@"test" afterDelay:5.0];
    
    
    //NSLog(@"Marker Updated %d", _marked);
    
    [self setNeedsDisplay];
}



-(void)setEmpty:(BOOL)empty
{
    _empty = empty;
    [self setNeedsDisplay];
}


#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.empty = YES;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


# pragma mark - Drawing

-(void)drawRect:(CGRect)rect
{
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.height/4];
    path.lineWidth = 3;
    [path addClip];
    
    if (self.isEmpty) {
        [self.emptyFillColor setFill];
        [self.emptyStrokeColor setStroke];
    }
    else {
        [self.fillColor setFill];
        [self.strokeColor setStroke];
        
        //[[UIColor grayColor] setFill];
        
    }
    
    [path fill];
    [path stroke];
    
    if (!self.isEmpty) {
        [self addContents];
        
        
    }
    
    if (self.isMarked) {
        //NSLog(@"marked");
        
        //[self drawMarker];
        
        //[self performSelector:@selector(<#selector#>) withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>]
        
        
        
        //[self performSelector:@selector(transitionForMarker) withObject:self afterDelay:2.0];
        //[self drawMarker];
        
        
        [self drawMarker];
        //[self drawMarker];
    }
    
}


-(void)transitionForMarker
{
    [UIView transitionWithView:self duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{[self drawMarker];} completion:nil];
    
}

-(void)saveContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}

//
//-(void)setNeedsDisplay
//{
//   // [super setNeedsDisplay];
//    [UIView transitionWithView:self duration:.25 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{[super setNeedsDisplay];} completion:nil];
//    
//    
//}


-(void)setNeedsDisplay
{
    
    UIViewAnimationOptions option = UIViewAnimationOptionTransitionNone;
    NSTimeInterval timedelay =0;
    double duration = .25;
    
    if (self.isMarked) {
        option = UIViewAnimationOptionTransitionFlipFromLeft;
        timedelay = duration;
        //duration = 1;
    }
    if (!self.isEmpty) {
        option = UIViewAnimationOptionTransitionFlipFromBottom;
    }
    
    NSNumber *dataOption = [NSNumber numberWithInt:option];
    NSNumber *dataDuration = [NSNumber numberWithDouble:duration];
    NSArray *array = @[dataOption, dataDuration];
    
    [self performSelector:@selector(performTransition:) withObject:array afterDelay:timedelay];
    
    
    
    
    
}


-(void)performTransition:(NSArray *)array
{
    NSNumber *option = array[0];
    NSNumber *duration = array[1];
    [UIView transitionWithView:self duration:duration.doubleValue options:option.intValue animations:^{[super setNeedsDisplay];} completion:nil];
}



-(void)addContents
{
    nil;
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawMarker
{
    
    //NSLog(@"drawing %@", self.marker);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *markerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    markerFont = [markerFont fontWithSize:(markerScaleFactor*self.bounds.size.height)];
    
    UIColor *markerColor = [UIColor blackColor];
    NSAttributedString *markerText = [[NSAttributedString alloc] initWithString:self.marker attributes:@{NSFontAttributeName: markerFont, NSForegroundColorAttributeName:markerColor, NSParagraphStyleAttributeName : paragraphStyle}];
    
    //CGRect rect;
    
    CGRect rect;
    rect.size = self.bounds.size;
    rect.origin.y= self.bounds.origin.y + ( (self.bounds.size.height/2)-(markerText.size.height/2));
    rect.origin.x = self.bounds.origin.x;
    
    
    [markerText drawInRect:rect];
    
    
    //NSLog(@"%f %f %f",markerText.size.height, markerFont.pointSize, markerText.size.height/markerFont.pointSize);
    
    
    
    
}
@end
