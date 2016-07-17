//
//  EightWayAnt.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "EightWayAnt.h"

@implementation EightWayAnt
-(id)initWithDirection:(enum EightWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol {
    self = [super initWithPosition:currentPos maxRow:maxRow maxCol:maxCol];
    if (self) {
        self.direction = direction;
        self.totalDir = direction;
    }
    return self;
}

+(NSInteger)NUM_DIR {
    return 8;
}
- (id)copyWithZone:(NSZone *)zone {
    EightWayAnt *ant = [[EightWayAnt alloc] initWithDirection:self.direction atPos:self.currentPos maxRow:self.maxRow maxCol:self.maxCol];
    return ant;
}

-(GridPoint*)getNeighbourAtDirection:(EightWayDirection) neighbourDirection {
    GridPoint *newPoint = [[GridPoint alloc] init];
    switch (neighbourDirection) {
        case RIGHT_8:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col + 1;
            break;
        case DOWN_RIGHT_8:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col + 1;
            break;
        case DOWN_8:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col;
            break;
        case DOWN_LEFT_8:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col - 1;
            break;
        case LEFT_8:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col - 1;
            break;
        case UP_LEFT_8:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col - 1;
            break;

        case UP_8:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col;
            break;
        case UP_RIGHT_8:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col + 1;
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
