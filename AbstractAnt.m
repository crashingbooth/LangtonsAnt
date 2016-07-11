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
NSInteger direction;
NSInteger totalDir;
NSInteger NUM_DIR;
BOOL isMusical;
MusicInterpretter *musInt;


-(id)initWithPosition:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol {
    self = [super init];
    if (self) {
        self.currentPos = currentPos;
        self.isMusical = NO;
        self.maxRow = maxRow;
        self.maxCol = maxCol;
    }
    return self;
}

+(NSInteger)NUM_DIR {
    //error
    
    NSLog(@"abstract, don't call me");
    return -1;
}



-(void)updateDirection:(NSInteger)turnDirection {
    //    NSInteger turnDirectionInteger = [turnDirection integerValue];
    self.direction += turnDirection;
    self.totalDir += turnDirection;
    if (self.direction < 0) {
        self.direction += [[self class] NUM_DIR]; // should be class method
    } else {
        self.direction %= [[self class] NUM_DIR];
    }
    if (self.isMusical) {
        [self.musInt playNoteFromDirection:self.direction];
    }
//
    NSLog([NSString stringWithFormat:@"dir: %li, %lu", self.totalDir, self.direction]);
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
