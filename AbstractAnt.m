//
//  AbstractAnt.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractAnt.h"

@implementation AbstractAnt

GridPoint *currentPos;
NSUInteger maxRow;
NSUInteger maxCol;
HexDirection direction;
NSInteger totalDir;
BOOL isMusical;
MusicInterpretter *musInt;

-(id)initWithDirection:(enum HexDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol {
    self = [super init];
    if (self) {
        self.direction = direction;
        self.currentPos = currentPos;
        self.totalDir = direction;
        self.isMusical = NO;
        self.maxRow = maxRow;
        self.maxCol = maxCol;
    }
    return self;
}

-(GridPoint*)moveToNewPosition {
    GridPoint *newPoint = [self getNeighbourAtDirection:self.direction];
    self.currentPos = newPoint;
    return newPoint;
}

-(void)addMusicInterpretter:(MusicInterpretter*)musInt {
    self.isMusical = YES;
    self.musInt = musInt;
}

@end
