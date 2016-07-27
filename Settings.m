//
//  Settings.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "Settings.h"


@implementation Settings
NSString *name;
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
BOOL defaultShape;
NSMutableArray *EightWayPresetNames;
NSMutableArray *SixWayPresetNames;
NSMutableArray *FourWayPresetNames;
NSMutableDictionary *presetDictionaries;
BOOL needToRebuild = NO;
CGFloat lengthToWidthRatio;


static NSString *const nameKey = @"name";
static NSString *const antTypeKey = @"antType";
static NSString *const statesListKey = @"statesList"; // Array of NSInteger
static NSString *const numRowsKey = @"numRows";
static NSString *const numColsKey = @"numCols";
static NSString *const speedKey = @"speed";
static NSString *const numAntsKey = @"numAnts";
static NSString *const shapeKey = @"shape";
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
        self.colorList = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor redColor], [UIColor blackColor], [UIColor purpleColor], [UIColor brownColor],[UIColor redColor], [UIColor blueColor],[UIColor blueColor],[UIColor lightGrayColor], [UIColor orangeColor] ];
       
        
    }
    [self buildPresets];
//     [self extractSettingsFromDict:self.presetDictionaries[@"standard Langton's Ant"]];
     [self extractSettingsFromDict:self.presetDictionaries[@"square filler"]];
  
    return self;
}

- (void)establishLengthToWidthRatio:(CGFloat)width length:(CGFloat)length {
    self.lengthToWidthRatio = length / width;
}

- (NSInteger)getAppropriateNumberOfRowsForScreen:(NSInteger)numCols {
    NSAssert(self.lengthToWidthRatio > 0 , @"lengthToWidthRatioUnset ");
    
    CGFloat rawNumber = (self.lengthToWidthRatio * (CGFloat)numCols);
    if (self.antType == SIX_WAY) {
        rawNumber = rawNumber/(1.5 * 0.577350269);
    }
    NSInteger numberOfRows = (NSInteger)rawNumber;
    if (numberOfRows % 2 == 1) {
        numberOfRows -= 1;
    }
    return numberOfRows;
}

- (void) extractSettingsFromDict: (NSDictionary*) dict {
    self.name =  dict[nameKey];
    self.antType = [dict[antTypeKey] integerValue];
    self.statesListInGrid = dict[statesListKey];
    self.numColsInGrid = [dict[numColsKey] integerValue];
    if (self.lengthToWidthRatio == 0) {
         self.numRowsInGrid = [dict[numRowsKey] integerValue];
    } else {
        self.numRowsInGrid = [self getAppropriateNumberOfRowsForScreen:self.numColsInGrid];
    }

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
    self.defaultShape = [dict[shapeKey] boolValue];
    
    self.settingsGrid = [[Grid alloc] initWithRows:self.numRowsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
    
    for (AbstractAnt *ant in self.antsInitialStatus) {
        [self.settingsGrid addAnt: [ant copyWithZone:nil]];
    }
    self.needToRebuild = YES;
}
- (void)recreateGrid {
     self.settingsGrid = [[Grid alloc] initWithRows:self.numRowsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
    self.settingsGrid.ants  = [[NSMutableArray alloc] init];
    
    NSInteger numberOfAnts = self.antsInitialStatus.count;
    for (int i = 0; i < numberOfAnts; i++) {
        AbstractAnt *originalAnt = self.antsInitialStatus[i];
        AbstractAnt *copyAnt = [originalAnt copyWithZone:nil];
        if (self.numColsInGrid != originalAnt.maxCol) {
            copyAnt.maxCol = self.numColsInGrid;
            copyAnt.maxRow = self.numRowsInGrid;
            copyAnt.currentPos.col = self.numColsInGrid / 2;
            copyAnt.currentPos.row = (self.numRowsInGrid / (numberOfAnts + 1)) * (i + 1);
        }
        
        [self.settingsGrid addAnt: copyAnt];

    }
   
    self.name = @"custom";
    self.needToRebuild = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateRuleCell" object:self];
    
    
    
}

- (void)addState {
    NSMutableArray *statesListCopy = [self.statesListInGrid mutableCopy];
    [statesListCopy addObject:@0];
    self.statesListInGrid = statesListCopy;
    [self recreateGrid];
}


#pragma mark - ModifyAnt Public Methods
- (void)addAnt {
    // called in ModifyAntTVC
    NSMutableArray *antsCopy = [self.antsInitialStatus mutableCopy];
    
    AbstractAnt *ant;
    GridPoint *start = [[GridPoint alloc] initWithRow: self.numRowsInGrid / 2 andCol: self.numColsInGrid / 2];
    if (self.antType == FOUR_WAY) {
        ant = [[FourWayAnt alloc] initWithDirection:0  atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
    } else if (self.antType == SIX_WAY) {
        ant = [[HexagonalAnt alloc] initWithDirection: 0 atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
    } else if (self.antType == EIGHT_WAY) {
        ant = [[EightWayAnt alloc] initWithDirection:0 atPos:start maxRow:self.numRowsInGrid maxCol:self.numColsInGrid];
    }
    [antsCopy addObject:ant];
    self.antsInitialStatus = antsCopy;
    [self recreateGrid];
}

- (void)removeAnt:(NSInteger)index {
    if (index > self.antsInitialStatus.count) {
        NSLog(@"invalid index");
    } else if (self.antsInitialStatus.count <= 1) {
        NSLog(@"Too few ants");
    } else {
        NSMutableArray *antsCopy = [self.antsInitialStatus mutableCopy];
        [antsCopy removeObjectAtIndex:index];
        self.antsInitialStatus = antsCopy;
        [self recreateGrid];
    }
}

- (void)modifyAnt:(NSInteger)index startRow:(NSInteger)startRow startCol:(NSInteger)startCol startDir:(NSInteger)startDir {
    NSMutableArray *antsCopy = [self.antsInitialStatus mutableCopy];
    AbstractAnt *ant = antsCopy[index];
    GridPoint *newStart = [[GridPoint alloc] initWithRow:startRow andCol:startCol];
    ant.currentPos = newStart;
    ant.direction = startDir;
    // recreateGrid will be called when ModifyAntTVC is closed

}

- (NSDictionary*) createDictFromCurrentSettings {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = self.name;
    dict[antTypeKey] = [NSNumber numberWithInteger:self.antType];
    dict[statesListKey] = self.statesListInGrid;
    dict[numRowsKey] = [NSNumber numberWithInteger:self.numRowsInGrid];
    dict[numColsKey] = [NSNumber numberWithInteger:self.numColsInGrid];
    dict[speedKey] = self.speed;
    dict[shapeKey] = [NSNumber numberWithBool: self.defaultShape];
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



- (void) buildPresets {
    self.eightWayPresetNames = [[NSMutableArray alloc] init];
    self.sixWayPresetNames = [[NSMutableArray alloc] init];
    self.fourWayPresetNames = [[NSMutableArray alloc] init];
    self.presetDictionaries = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"symmetrical hexagon 4-state";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] = @[ @(-1), @(-1), @1, @1];
    dict[numRowsKey] = [NSNumber numberWithInteger: 60];
    dict[numColsKey] = [NSNumber numberWithInteger: 60];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    NSArray *startRows = @[@30];
    NSArray *startCols = @[@30];
    NSArray *startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"symmetrical hex 2-state";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] = @[ @1, @-1];
    dict[numRowsKey] = [NSNumber numberWithInteger: 30];
    dict[numColsKey] = [NSNumber numberWithInteger: 20];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@15];
    startCols = @[@10];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"complex hex-highway";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] = @[ @2, @-2, @2, @2, @2];
    dict[numRowsKey] = [NSNumber numberWithInteger: 90];
    dict[numColsKey] = [NSNumber numberWithInteger: 60];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@30];
    startCols = @[@30];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"labyrinth maker";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] = @[ @-1, @2, @-1];
    dict[numRowsKey] = [NSNumber numberWithInteger: 90];
    dict[numColsKey] = [NSNumber numberWithInteger: 60];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@30];
    startCols = @[@30];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"spiral";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] =  @[@-1,@-2,@0, @3, @-2, @-1,@2];

    NSInteger rows = 200;
    NSInteger cols = 150;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 2)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"horizontal gridmaker";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[ @(3), @(-2), @4, @2, @-3,@1];
    rows = 106;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@(rows / 4), @(rows / 2)];
    startCols = @[@(cols / 2), @(cols / 4)];
    startDirections = @[@2,@3];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"standard Langton's Ant";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @1, @-1];
    rows = 80;
    cols = 60;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 2)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"symmetrical 4a";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @1, @-1, @-1, @1];
    rows = 80;
    cols = 60;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 2)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"symmetrical 4b";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @1, @1, @-1, @-1];
    rows = 80;
    cols = 60;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 2)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"square filler";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @-1,@1, @1,@1, @1,@1, @-1,@-1, @1 ];
//    LR RR RR LL R
    rows = 150;
    cols = 150;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:NO];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 2)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"expanding triangle (be patient)";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @1,@1,@-1, @-1,@-1,@1,@-1, @-1,@-1,@1,@1,@1];
//   RRLLLRLLLRRR
    rows = 150;
    cols = 150;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:NO];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(30)];
    startCols = @[@120];
    startDirections = @[@3];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    
    
    
    
    // 4
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"diagonal gridmaker";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[ @(3), @(-1), @4,@0, @1, @-3];
    rows = 106;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@(rows / 4), @(rows / 2)];
    startCols = @[@(cols / 2), @(cols / 4)];
    startDirections = @[@0,@1];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    // 4
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"bender";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[ @0,@4,@3];
    rows = 106;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 4)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"basic 8-way";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[@1,@-1];
    rows = 106;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 4)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"period 13";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[@3,@-2,@4, @2, @-3] ;
    rows = 106;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@(rows / 4), @(rows / 2)];
    startCols = @[@(cols / 2), @(cols / 4)];
    startDirections = @[@0,@1];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"high period";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[@3,@3,@3, @0] ;
    rows = 106;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@(rows / 4)];
    startCols = @[@(cols / 2)];
    startDirections = @[@0,@1];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];

    
    

}

- (void)addPresetDictToPresetStorage:(NSDictionary*) dict {
    AntType type = [dict[antTypeKey] integerValue];
    NSString *name = dict[nameKey];
    if (type == FOUR_WAY) {
        [self.fourWayPresetNames addObject:dict[nameKey]];
    } else if (type == SIX_WAY) {
        [self.sixWayPresetNames addObject:dict[nameKey]];
    } else if (type == EIGHT_WAY) {
        [self.eightWayPresetNames addObject:dict[nameKey]];
    }
//    self.presetDictionaries[name] = @"happy birthday";
    self.presetDictionaries[name] = dict;
    
//    [self.presetDictionaries setValue:dict forKey:dict[nameKey]];
}

- (NSString*)getStateName:(NSInteger)stateNumber forAntType:(AntType)type {
    NSString *stateName;
    switch (stateNumber) {
        case 0:
            stateName = @"N";
            break;
        case 1:
            if (type == FOUR_WAY) {
                stateName = @"R";
            } else {
                stateName = @"R1";
            }
            break;
        case -1:
            if (type == FOUR_WAY) {
                stateName = @"L";
            } else {
                stateName = @"L1";
            }
            break;
        case 2:
            if (type == FOUR_WAY) {
                stateName = @"U";
            } else {
                stateName = @"R2";
            }
            break;
        case -2:
            stateName = @"L2";
            break;
        case 3:
            if (type == SIX_WAY) {
                stateName = @"U";
            } else {
                stateName = @"R3";
            }
            break;
        case -3:
            stateName = @"L3";
            break;
        case 4:
            stateName = @"U";
            break;
        default:
            stateName = @"INVALID";
            break;
    }
    return stateName;
}

- (NSString*)getRuleSystemAsString {
    NSMutableString *ruleString = [[NSMutableString alloc] init];
    for (NSNumber *ruleNum in self.statesListInGrid) {
        NSString *ruleNumAsString = [self getStateName:[ruleNum integerValue] forAntType:self.antType];
        [ruleString appendString:ruleNumAsString];
        [ruleString appendString:@" "];
    }
    return ruleString;
}

- (NSString*)getFullDescription {
    NSString *typeString;
    NSString *numAntsString;
    NSString *ruleString;
    switch (self.antType) {
        case FOUR_WAY:
            typeString = @"Four way";
            break;
        case SIX_WAY:
            typeString = @"Six way";
            break;
        case EIGHT_WAY:
            typeString = @"Eight way";
            break;
    }
    numAntsString = [NSString stringWithFormat:@"%li ant(s)", self.settingsGrid.ants.count];
    ruleString = [self getRuleSystemAsString];
    
    return [NSString stringWithFormat:@"%@ - %@ - %@",typeString, numAntsString, ruleString ];
    
}

- (NSString*)getFullDescription:(NSDictionary*)dictWithCorrectAntNum {
    // b/c LoadSettingsView only displays one ant, so use it's original dict to get correct val
    NSString *typeString;
    NSString *numAntsString;
    NSString *ruleString;
    switch (self.antType) {
        case FOUR_WAY:
            typeString = @"Four way";
            break;
        case SIX_WAY:
            typeString = @"Six way";
            break;
        case EIGHT_WAY:
            typeString = @"Eight way";
            break;
    }
    numAntsString = [NSString stringWithFormat:@"%li ant(s)", [dictWithCorrectAntNum[numAntsKey] integerValue]];
    ruleString = [self getRuleSystemAsString];
    
    return [NSString stringWithFormat:@"%@ - %@ - %@",typeString, numAntsString, ruleString ];
    
}



//  8way  states = @[@3,@-2,@4, @2, @-3] , 60 x 40 good  ;
//  8way  states = @[@3,@-2,@4, @2, @-3] , 70 x 55 good, row/4 col/2, row/2 col/4  ;

@end
