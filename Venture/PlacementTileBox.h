//
//  TileBox.h
//  Venture
//
//  Created by Gaurav Verma on 10/31/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlacementTile.h"

@interface PlacementTileBox : NSObject


- (PlacementTile *) drawRandomTile;
-(int)tilesLeft;
- (instancetype)initWithRow:(int)nRows column:(int)nColumns;

@property (nonatomic) int maxPlacementTiles;


@end
