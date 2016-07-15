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
NSArray *statesListInGrid;
NSInteger numStates;
NSInteger numRowsInGrid;
NSInteger numColsInGrid;
NSArray *colorList;
NSArray *antsInitialStatus;
NSInteger numAnts;
Grid *settingsGrid;


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
        self.statesListInGrid = @[@-1, @1];
        self.numRowsInGrid = 40;
        self.numColsInGrid = 40;
        self.colorList = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
        GridPoint *start = [[GridPoint alloc] initWithRow:self.numRowsInGrid / 2 andCol:self.numColsInGrid / 2];
        FourWayAnt *ant = [[FourWayAnt alloc] initWithDirection:RIGHT_4 atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
        self.settingsGrid = [[Grid alloc] initWithRows:self.numRowsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
        [self.settingsGrid addAnt:ant];
        
    }
    return self;
}

-(NSInteger) numStates {
    return statesListInGrid.count;
}

-(NSInteger) numAnts {
    return antsInitialStatus.count;
}

//  8way  states = @[@3,@-2,@4, @2, @-3] , 60 x 40 good  ;
//  8way  states = @[@3,@-2,@4, @2, @-3] , 70 x 55 good, row/4 col/2, row/2 col/4  ;

@end
