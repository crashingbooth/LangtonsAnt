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
    }
    return self;
}

+(NSInteger)NUM_DIR {
    return 4;
}

- (id)copyWithZone:(NSZone *)zone {
    FourWayAnt *ant = [[FourWayAnt alloc] initWithDirection:self.direction atPos:self.currentPos maxRow:self.maxRow maxCol:self.maxCol];
    return ant;
}

-(GridPoint*)getNeighbourAtDirection:(FourWayDirection) neighbourDirection {
    GridPoint *newPoint = [[GridPoint alloc] init];
    switch (neighbourDirection) {
        case RIGHT_4:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col + 1;
            break;
        case DOWN_4:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col;
            break;
        case LEFT_4:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col - 1;
            break;
        case UP_4:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col;
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
