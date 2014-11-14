//
//  GameBoardTile.h
//  Venture
//
//  Created by Gaurav Verma on 11/7/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameBoardTile : NSObject

@property (nonatomic) int companyType;   //-1 for blank square 0 for occupied square, 1, 2, 3, etc. for others
@property (nonatomic, strong) NSMutableArray *neighboringTiles;
@property (nonatomic) int row;
@property (nonatomic) int column;

@end
