//
//  Grid.m
//  Langston's Ant
//
//  Created by Jeff Holtzkener on 6/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grid.h"
#import "AbstractAnt.h"
#import "HexagonalAnt.h"

@implementation Grid : NSObject
NSUInteger numRows;
NSUInteger numCols;
NSMutableArray *ants;
NSMutableArray *matrix;
NSArray *statesList;


-(id)initWithRows:(NSUInteger)numRows andCols:(NSUInteger)numCols andStates:(NSArray*)statesList {
    self = [super init];
    if (self) {
        self.numRows = numRows;
        self.numCols = numCols;
        self.statesList = statesList;
        self.matrix = [[NSMutableArray alloc] init ];
        self.ants = [[NSMutableArray alloc] init ];
    }
    return self;
}


-(void)buildZeroStateMatrix {
    for (int row = 0; row < self.numRows; row++) {
        NSMutableArray *newRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < self.numCols; col++) {
            [newRow addObject:[NSNumber numberWithInteger:0]];
        }
        [self.matrix addObject:newRow];
    }
}

-(void)logMatrix {
    for (NSMutableArray *row in self.matrix) {
        NSLog([row componentsJoinedByString:@" "]);
    
    }
}

-(void)addAnt:(HexagonalAnt*)ant {
    // ant will keep track of its own location
    [self.ants addObject:ant ];
}

-(NSMutableArray*)update{
    // for each ant:
    // move ant to new position
    // get state for new pos
    // change newposition state
    // update ant state and posiiton
    
    // returns array of positions which have changed
    
    NSMutableArray* changedPositions = [[NSMutableArray alloc] init];
    
    for (AbstractAnt *ant in self.ants) {
        GridPoint *newPos = [ant moveToNewPosition];
        NSInteger stateAtPos = [[[self.matrix objectAtIndex:newPos.row] objectAtIndex:newPos.col] integerValue];
        
        
        
        NSInteger dirOfState = [[self.statesList objectAtIndex:stateAtPos] integerValue];
        //        NSLog([NSString stringWithFormat:@"stateAtPos: %lu, dir adjust: %li", stateAtPos, (long)dirOfState]);
        [ant updateDirection:dirOfState];
        
        stateAtPos = (stateAtPos + 1) % self.statesList.count;
        [[self.matrix objectAtIndex:newPos.row] replaceObjectAtIndex:newPos.col withObject:[NSNumber numberWithInteger:stateAtPos]];
        [changedPositions addObject:newPos];
        
    }
    return changedPositions;
    
    
}

@end
