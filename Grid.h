//
//  Grid.h
//  Langston's Ant
//
//  Created by Jeff Holtzkener on 6/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractAnt.h"

@interface Grid : NSObject
@property (nonatomic) NSUInteger numRows;
@property (nonatomic) NSUInteger numCols;
@property (nonatomic) NSUInteger numStates;
@property (nonatomic, strong) NSMutableArray *matrix;
@property (nonatomic, strong) NSArray *statesList;
@property (nonatomic, strong) NSMutableArray *ants;

-(void)addAnt:(AbstractAnt*)ant atRow:(NSUInteger)row andCol:(NSUInteger)col;
-(void)setStates:(NSArray*)stateValues;
-(id)initWithRows:(NSUInteger)numRows andCols:(NSUInteger)numCols andStates:(NSUInteger)numStates;
-(NSMutableArray*)update;
-(void)buildZeroStateMatrix;
-(void)logMatrix;



@end
