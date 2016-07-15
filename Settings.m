//
//  Settings.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "Settings.h"


@implementation Settings
AntType antType;
NSArray *statesList;
NSInteger numStates;
NSInteger numRows;
NSInteger numCols;
NSArray *colorList;
NSArray *antList;
NSInteger numAnts;
Grid *grid;


+ (Settings *)sharedInstance {
    static Settings *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Settings alloc] init];
    });
    
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        self.antType = FOUR_WAY;
        self.statesList = @[@-1, @1];
        self.numRows = 40;
        self.numCols = 40;
        self.colorList = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
        GridPoint *start = [[GridPoint alloc] initWithRow:self.numRows / 2 andCol:self.numCols / 2];
        FourWayAnt *ant = [[FourWayAnt alloc] initWithDirection:RIGHT_4 atPos:start maxRow:self.numRows maxCol:self.numCols];
        self.grid = [[Grid alloc] initWithRows:self.numRows andCols:self.numCols andStates:self.statesList];
        [self.grid addAnt:ant];
        
    }
    return self;
}

-(NSInteger) numStates {
    return statesList.count;
}

-(NSInteger) numAnts {
    return antList.count;
}

@end
