//
//  HexagonalAnt.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "HexagonalAnt.h"

@implementation HexagonalAnt


-(id)initWithDirection:(enum HexDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol {
    self = [super initWithPosition:currentPos maxRow:maxCol maxCol:maxCol];
    if (self) {
        self.direction = direction;
        self.totalDir = direction;
    }
    return self;
}
+(NSInteger)NUM_DIR {
    return 6;
}
- (id)copyWithZone:(NSZone *)zone {
    HexagonalAnt *ant = [[HexagonalAnt alloc] initWithDirection:self.direction atPos:self.currentPos maxRow:self.maxRow maxCol:self.maxCol];
    return ant;
}






-(GridPoint*)getNeighbourAtDirection:(HexDirection) neighbourDirection {
    GridPoint *newPoint = [[GridPoint alloc] init];
    switch (neighbourDirection) {
        case RIGHT:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col + 1;
            break;
        case DOWN_RIGHT:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col;
            break;
        case DOWN_LEFT:
            newPoint.row = self.currentPos.row + 1;
            newPoint.col = self.currentPos.col - 1;
            break;
        case LEFT:
            newPoint.row = self.currentPos.row;
            newPoint.col = self.currentPos.col - 1;
            break;
        case UP_LEFT:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col - 1;
            break;
        case UP_RIGHT:
            newPoint.row = self.currentPos.row - 1;
            newPoint.col = self.currentPos.col;
            break;
            
        default:
            break;
    }
    
    // odd rows are offset horizonatally by 1
    if (self.currentPos.row % 2 == 1) {
        if (!(neighbourDirection == LEFT || neighbourDirection == RIGHT))
            newPoint.col += 1;
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
