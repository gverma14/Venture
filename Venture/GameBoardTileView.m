//
//  GameBoardTileView.m
//  Venture
//
//  Created by Gaurav Verma on 11/7/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "GameBoardTileView.h"

const double companyTileScaleFactor = .8;

@interface GameBoardTileView()

@property (nonatomic) double markerAlpha;

@end

@implementation GameBoardTileView


-(void)setCompanyType:(int)companyType
{
    _companyType = companyType;
    [self setNeedsDisplay];
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.companyType = -1;
    return self;
    
}

-(double)markerAlpha
{
    return .5;
}
-(UIColor *)fillColor
{
    switch (self.companyType) {
        
        
        
        case 7:
            return [UIColor blackColor];
            break;
        case 6:
            return [UIColor purpleColor];
            break;
        case 5:
            return [UIColor blueColor];
            break;
        case 4:
            return [UIColor cyanColor];
            break;
        case 3:
            return [UIColor greenColor];
            break;
        case 2:
            return [UIColor yellowColor];
            break;
        case 1:
            return [UIColor redColor];
            break;
        case 0:
            //return [UIColor colorWithRed:165.0/255 green:0 blue:33.0/255 alpha:1];
            return [UIColor clearColor];
            break;
        default:
            return [UIColor whiteColor];
            break;
    }
}

-(UIColor *)strokeColor
{
    if (self.companyType == 0) {
        return [UIColor whiteColor];
    }
    else {
        return [super strokeColor];
    }
    
}

- (void)drawMarker
{
    
    
    
    UIImage *image = [UIImage imageNamed:@"companytileicon_0_0.png"];
    UIImage *alphaImage = [GameBoardTileView imageByAddingAlpha:self.markerAlpha usingImage:image];
    
    if (image) {
        CGRect bounds = self.bounds;
        //NSLog(@"%f width %f height", bounds.size.width, bounds.size.height);
        CGRect newBounds = CGRectInset(bounds, (1.0-companyTileScaleFactor)/2*bounds.size.width, (1.0-companyTileScaleFactor)/2*bounds.size.height);
        //cgcontexttran
        [alphaImage drawInRect:newBounds];
    }
    
    
    //CGContextRestoreGState(UIGraphicsGetCurrentContext());

}


+(UIImage *)imageByAddingAlpha:(double)alpha usingImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -image.size.height);
    CGContextSetAlpha(context, alpha);
    CGContextDrawImage(context, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)addContents
{
    
    if (!self.isEmpty) {
        if (self.companyType >= 0) {
            NSString *fileName = [NSString stringWithFormat:@"companytileicon_%d",self.companyType];
            UIImage *image = [UIImage imageNamed:fileName];
            if (image) {
                
                //NSLog(@"adding");
                CGRect bounds = self.bounds;
                //NSLog(@"%f width %f height", bounds.size.width, bounds.size.height);
                
                CGRect newBounds = CGRectInset(bounds, (1.0-companyTileScaleFactor)/2*bounds.size.width, (1.0-companyTileScaleFactor)/2*bounds.size.height);
                //NSLog(@"old bounds %f %f", bounds.size.width, bounds.size.height);
                //NSLog(@"new bounds %f %f", newBounds.size.width, newBounds.size.height);
                
                [image drawInRect:newBounds];
            }
        }
    }
}


@end
