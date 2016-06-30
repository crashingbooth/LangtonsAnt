//
//  Ant.m
//  Langston's Ant
//
//  Created by Jeff Holtzkener on 6/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "Ant.h"
#import <Foundation/Foundation.h>

@implementation Ant : NSObject
NSUInteger currentRow;
NSUInteger currentCol;
Direction direction;
const NSInteger NUM_DIR = 4;

-(id)initWithDirection:(enum Direction)direction atRow:(NSUInteger)currentRow atCol:(NSUInteger)currentCol {
    self = [super init];
    if (self) {
        self.direction = direction;
        self.currentCol = currentCol;
        self.currentRow = currentRow;
    }
    return self;
}

-(void)updateDirection:(NSInteger)turnDirection {
//    NSInteger turnDirectionInteger = [turnDirection integerValue];
    self.direction += turnDirection;
    if (self.direction < 0) {
        self.direction = NUM_DIR - 1;
    } else {
        self.direction %= NUM_DIR;
    }
}





@end
