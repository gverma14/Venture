//
//  TileBox.m
//  Venture
//
//  Created by Gaurav Verma on 10/31/14.
//  Copyright (c) 2014 Shiny Mango. All rights reserved.
//

#import "PlacementTileBox.h"


@interface PlacementTileBox()


@property (strong, nonatomic) NSMutableArray *placementTiles;

@end

@implementation PlacementTileBox

- (instancetype)initWithRow:(int)nRows column:(int)nColumns
{
    self = [super init];
    for (int row = 0; row < nRows; row++) {
        
        for (int col = 0; col < nColumns; col++) {
            
            PlacementTile *tile = [[PlacementTile alloc] init];
            tile.row = row;
            tile.col = col;
            [self.placementTiles addObject:tile];
        }
        
    }
    
    return self;
    

    
    
}


-(int)tilesLeft
{
    return [self.placementTiles count];
}

-(int)maxPlacementTiles
{
    return 108;
}


- (PlacementTile *) drawRandomTile;
{

    if ([self.placementTiles count] > 0) {
        int index = [self generateRandomNumber:0 end:([self.placementTiles count]-1)];
        PlacementTile *tile = [self.placementTiles objectAtIndex:index];
        [self.placementTiles removeObjectAtIndex:index];
        
        return tile;
        
    }
    
    return nil;

}



-(int) generateRandomNumber:(int)begin end:(int) end {
    
    return arc4random()%(end+1 - begin) +begin;
    
}




-(NSMutableArray *)placementTiles
{
    if (!_placementTiles) {
        _placementTiles = [[NSMutableArray alloc] init];
    }
    return _placementTiles;
}







@end
