//
//  GridPoint.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/1/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

// note:Implemented as class so that it can be stored easily in NSArray
#import "GridPoint.h"

@implementation GridPoint
NSInteger row;
NSInteger col;

-(id)initWithRow:(NSInteger)row andCol:(NSInteger)col {
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        self.row = 0;
        self.col = 0;
    }
    return self;
}
@end
