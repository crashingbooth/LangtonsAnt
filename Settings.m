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
NSNumber *speed;

static NSString *const antTypeKey = @"antType";
static NSString *const numStatesKey = @"numStates";
static NSString *const statesListKey = @"statesList"; // Array of NSInteger
static NSString *const numRowsKey = @"numRows";
static NSString *const numColsKey = @"numCols";
static NSString *const speedKey = @"speed";
static NSString *const numAntsKey = @"numAnts";
static NSString *const antDirectionKey = @"antDirections"; // Array of NSInteger
static NSString *const antStartRowsKey = @"antStartRows"; // Array of NSInteger
static NSString *const antStartColsKey = @"antStartCows"; // Array of NSInteger


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
        self.antsInitialStatus = @[[ant copyWithZone:nil]];
        self.settingsGrid = [[Grid alloc] initWithRows:self.numRowsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
        [self.settingsGrid addAnt:ant];
        self.speed = [NSNumber numberWithFloat:0.13];
        
    }
    [self createDictFromCurrentSettings];
    return self;
}

- (void) extractSettingsFromDict: (NSDictionary*) dict {
    self.antType = [dict[antTypeKey] integerValue];
    self.statesListInGrid = dict[statesListKey];
    self.numRowsInGrid = [dict[numRowsKey] integerValue];
    self.numColsInGrid = [dict[numColsKey] integerValue];
    NSInteger numAnts = [dict[numAntsKey] integerValue];
    NSArray *startRows = dict[antStartRowsKey];
    NSArray *startCols = dict[antStartColsKey];
    NSArray *startDirections = dict[antDirectionKey];
    NSMutableArray *newAnts = [[NSMutableArray alloc] init];
    for (int i = 0; i < numAnts; i++) {
        AbstractAnt *ant;
        GridPoint *start = [[GridPoint alloc] initWithRow:[startRows[i] integerValue] andCol:[startCols[i] integerValue]];
        if (self.antType == FOUR_WAY) {
            ant = [[FourWayAnt alloc] initWithDirection:[startDirections[i] integerValue] atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
        } else if (self.antType == SIX_WAY) {
            ant = [[HexagonalAnt alloc] initWithDirection:[startDirections[i] integerValue] atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
        } else if (self.antType == EIGHT_WAY) {
            ant = [[EightWayAnt alloc] initWithDirection:[startDirections[i] integerValue] atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
        }
        
        [newAnts addObject:ant];
    }
    self.antsInitialStatus = newAnts;
    self.speed = dict[speedKey];
    
    self.settingsGrid = [[Grid alloc] initWithRows:self.numColsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
    
    for (AbstractAnt *ant in self.antsInitialStatus) {
        [self.settingsGrid addAnt: [ant copyWithZone:nil]];
    }
}

- (NSDictionary*) createDictFromCurrentSettings {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[antTypeKey] = [NSNumber numberWithInteger:self.antType];
    dict[numStatesKey] = [NSNumber numberWithInteger: self.statesListInGrid.count];
    dict[statesListKey] = self.statesListInGrid;
    dict[numRowsKey] = [NSNumber numberWithInteger:self.numRowsInGrid];
    dict[numColsKey] = [NSNumber numberWithInteger:self.numColsInGrid];
    dict[speedKey] = self.speed;
    dict[numAntsKey] = [NSNumber numberWithInteger:self.antsInitialStatus.count];
    NSMutableArray *startRows = [[NSMutableArray alloc] init];
    NSMutableArray *startCols = [[NSMutableArray alloc] init];
    NSMutableArray *startDirections = [[NSMutableArray alloc] init];
    for (AbstractAnt *ant in self.antsInitialStatus) {
        [startRows addObject: [NSNumber numberWithInteger: ant.currentPos.row]];
        [startCols addObject: [NSNumber numberWithInteger: ant.currentPos.col]];
        [startDirections addObject:[NSNumber numberWithInteger:ant.direction]];
    }
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    return dict;
}

- (NSDictionary*) testSettings{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[numStatesKey] = [NSNumber numberWithInteger: 4];
    dict[statesListKey] = @[ @(-1), @(-1), @1, @1];
    dict[numRowsKey] = [NSNumber numberWithInteger: 100];
    dict[numColsKey] = [NSNumber numberWithInteger: 100];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    NSArray *startRows = @[@20, @80];
    NSArray *startCols = @[@80, @20];
    NSArray *startDirections = @[@0,@0];
    
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    return dict;
    
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
