//
//  FourWayAnt.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "FourWayAnt.h"

@implementation FourWayAnt
-(id)initWithDirection:(enum FourWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol {
    self = [super initWithPosition:currentPos maxRow:maxCol maxCol:maxCol];
    if (self) {
        self.direction = direction;
        self.totalDir = direction;
        self.NUM_DIR = 4;
    }
    return self;
}

-(GridPoint*)getNeighbourAtDirection:(FourWayDirection) neighbourDirection {
    GridPoint *newPoint = [[GridPoint alloc] init];
    switch (neighbourDirection) {
        case RIGHT:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col + 1;
            break;
        case DOWN:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col;
            break;
        case LEFT:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col - 1;
            break;
        case UP:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col - 1;
            break;

            
        default:
            break;
    }
    
    
    
    // handle borders
    if (newPoint.row < 0) {
        newPoint.row = self.maxRow - 1;
    }
    if (newPoint.col < 0) {
        newPoint.col = self.maxCol - 1;
    }
    if (newPoint.row >= self.maxRow) {
        newPoint.row = 0;
    }
    if (newPoint.col >= self.maxCol) {
        newPoint.col = 0;
    }
    return newPoint;
    
}
@end
