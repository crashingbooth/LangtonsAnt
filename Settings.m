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
NSArray *colorList;  // each entry in array is an array of color, index correspands to colorscheme
NSArray *antsInitialStatus; // copies, because actual ants change
NSInteger numAnts;
Grid *settingsGrid;
NSNumber *speed;
BOOL defaultShape;
NSInteger colorScheme;

NSMutableArray *EightWayPresetNames;
NSMutableArray *SixWayPresetNames;
NSMutableArray *FourWayPresetNames;
NSMutableDictionary *presetDictionaries;
BOOL needToRebuild = NO;
CGFloat lengthToWidthRatio;


static NSString *const userDefaultsPresetNameKey = @"userDefaultsPresetName";
static NSString *const userDefaultsPresetDictKey = @"userDefaultsPresetDict";



#pragma mark - Creattion and Initialization
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
    return self;
}

- (NSString*)randomStartingPreset {
    NSInteger presetType = arc4random_uniform(3);
    
    
    switch (presetType) {
        case 0:
            return self.fourWayPresetNames[arc4random_uniform((u_int)self.fourWayPresetNames.count)];
            break;
        case 1:
            return self.sixWayPresetNames[arc4random_uniform((u_int)self.sixWayPresetNames.count)];
            break;
        case 2:
            return self.eightWayPresetNames[arc4random_uniform((u_int)self.eightWayPresetNames.count)];
            break;
            
        default:
            break;
    }
    return @"";
}


#pragma mark - Extracting and Providing Values for Missing/Inappropriate Settings
- (void) extractSettingsFromDict: (NSDictionary*) dict {
    // this must be called after length ratio is set
    
    self.name =  dict[nameKey];
    self.antType = [dict[antTypeKey] integerValue];
    self.statesListInGrid = dict[statesListKey];
    self.numColsInGrid = [dict[numColsKey] integerValue];
    
    // in case ratio is not set - shouldn't be called ... delete??
    if (self.lengthToWidthRatio == 0) {
        NSLog(@"length ratio not set for %@", self.name);
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
        
        // negative startRow or startCol values are default
        NSInteger startRow = [startRows[i] integerValue];
        if (startRow < 0) {
            startRow = (self.numRowsInGrid / (numAnts + 1) ) * (i + 1) - 1;
            NSLog(@"used default -1 row %li, %li", self.numRowsInGrid, startRow);
        }
        
        NSInteger startCol = [startCols[i] integerValue];
        if (startCol < 0) {
            startCol = (self.numColsInGrid / 2) - 1;
            NSLog(@"used default -1 col");
        }
        
        
        GridPoint *start = [[GridPoint alloc] initWithRow:startRow andCol:startCol];
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
    
    
    NSInteger colorVal =  [dict[colorSchemeKey] integerValue];
    if (colorVal == -1) {
        self.colorScheme =  arc4random_uniform((UInt32)[Settings masterColorList].count);
    } else {
        self.colorScheme = colorVal;
    }
    self.colorList = [self assignColorScheme:self.colorScheme];
    
    self.settingsGrid = [[Grid alloc] initWithRows:self.numRowsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
    
    // MUSIC
    self.musicIsOn = [dict[musicIsOnKey] boolValue];
    self.musicTypeArray = [dict[musicTypeArrayKey] mutableCopy];
    self.scaleName = [dict[musicScaleKey] mutableCopy];
    self.panArray = [dict[musicLinePanArrayKey] mutableCopy];
    self.volArray = [dict[musicVolArrayKey] mutableCopy];
    self.registerArray = [dict[musicRegisterArrayKey] mutableCopy];
    self.midiVoiceArray = [dict[midiVoiceArrayKey] mutableCopy];
    
    for (AbstractAnt *ant in self.antsInitialStatus) {
        [self.settingsGrid addAnt: [ant copyWithZone:nil]];
    }
    [self updateMusicStatusOfAnts];
    self.needToRebuild = YES;
}

- (void)establishLengthToWidthRatio:(CGFloat)width length:(CGFloat)length {
    self.lengthToWidthRatio = length / width;
    
    if (self.numRowsInGrid != [self getAppropriateNumberOfRowsForScreen:self.numColsInGrid]) {
        self.numRowsInGrid = [self getAppropriateNumberOfRowsForScreen:self.numColsInGrid];
        NSLog(@"mod num rows");
        [self makeInitialAntsConform];
    }
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

- (void) updateMusicStatusOfAnts {
    NSInteger numAnts = self.settingsGrid.ants.count;
    
    if (!self.scaleName) {
        self.scaleName = @"stacked3rds";
        NSLog(@"using default scale");
    }
    
    if (!self.musicTypeArray) {
        self.musicTypeArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.midiVoiceArray) {
        self.midiVoiceArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.panArray) {
        self.panArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.registerArray) {
        self.registerArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.volArray) {
        self.volArray = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < numAnts; i++) {
        MusicInterpretter *musInt;
        AbstractMusicLine *line;
        
        if (self.musicTypeArray.count <= i) {
            [self.musicTypeArray addObject: @YES];
            [self.midiVoiceArray addObject: @108];
            [self.panArray addObject: @0];
            [self.registerArray addObject: [NSNumber numberWithInt:(i % 3)]];
            [self.volArray addObject: @0.6];
        }
        BOOL isMelodic = [self.musicTypeArray[i] boolValue];
        float pan = [self.panArray[i] floatValue];
        float vol = [self.volArray[i] floatValue];

        if (isMelodic) {
            NSNumber *voice = self.midiVoiceArray[i];
            NSInteger root = [self.registerArray[i] integerValue] * 12 + 48;
            line = [[MidiLine alloc] initWithGMMidiNumber:voice root:root channel:[NSNumber numberWithInt:i] pan:pan vol:vol];
            musInt = [[MusicInterpretter alloc] initWithMusicLine:line scale:self.scaleName];
        } else {
            line = [[DrumLine alloc] initWithRegister:self.registerArray[i] pan:pan vol:vol];
            musInt = [[MusicInterpretter alloc] initWithMusicLine:line scale:@"drum1"];
        }
        [self.settingsGrid.ants[i] addMusicInterpretter:musInt];
    }
}



- (void)recreateGrid {
    self.settingsGrid = [[Grid alloc] initWithRows:self.numRowsInGrid andCols:self.numColsInGrid andStates:self.statesListInGrid];
    [self makeInitialAntsConform];
    [self copyInitialAntsToSettingsGrid];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    self.name = [NSString stringWithFormat:@"custom: %@",dateString];
    self.needToRebuild = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateRuleCell" object:self];
    
}

- (void)makeInitialAntsConform {
    
    NSInteger numberOfAnts = self.antsInitialStatus.count;
    NSMutableArray *newInitialAnts = [[NSMutableArray alloc] init];
    for (int i = 0; i < numberOfAnts; i++) {
        AbstractAnt *originalAnt = self.antsInitialStatus[i];
        AbstractAnt *copyAnt = [originalAnt copyWithZone:nil];
        if (self.numColsInGrid != originalAnt.maxCol || originalAnt.currentPos.col >= self.numColsInGrid) {
            NSLog(@"modified ant position");
            copyAnt.maxCol = self.numColsInGrid;
            copyAnt.maxRow = self.numRowsInGrid;
            copyAnt.currentPos.col = self.numColsInGrid / 2 - 1;
            copyAnt.currentPos.row = (self.numRowsInGrid / (numberOfAnts + 1)) * (i + 1);
        }
        
        [newInitialAnts addObject:copyAnt];
        
    }
    self.antsInitialStatus = newInitialAnts;
    
}

- (void)copyInitialAntsToSettingsGrid {
    self.settingsGrid.ants  = [[NSMutableArray alloc] init];
    
    NSInteger numberOfAnts = self.antsInitialStatus.count;
    for (int i = 0; i < numberOfAnts; i++) {
        AbstractAnt *originalAnt = self.antsInitialStatus[i];
        AbstractAnt *copyAnt = [originalAnt copyWithZone:nil];
        [self.settingsGrid addAnt: copyAnt];
    }
}

- (NSArray*)assignColorScheme:(NSInteger)colorIndex {
    NSArray* colors = [[NSArray alloc] init];
    // change ColorShemeTVC
    colors = [Settings masterColorList][colorIndex];
    
    return colors;
}

#pragma mark - Modifying Settings

- (void)addState {
    NSMutableArray *statesListCopy = [self.statesListInGrid mutableCopy];
    [statesListCopy addObject:@0];
    self.statesListInGrid = statesListCopy;
    [self recreateGrid];
}


- (void)setMusicIsOn:(BOOL)musicIsOn {
    _musicIsOn = musicIsOn;
    if (self.musicIsOn) {
        if ([self.speed floatValue] < 0.2) {
            self.speed = @0.2;
            NSLog(@"speed set because of music");
        }
    }
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
        NSMutableArray *tempArr = [self.antsInitialStatus mutableCopy];
        [tempArr removeObjectAtIndex:index];
        self.antsInitialStatus = tempArr;
        
        tempArr = [self.musicTypeArray mutableCopy];
        [tempArr removeObjectAtIndex:index];
        self.musicTypeArray = tempArr;
        
        tempArr = [self.midiVoiceArray mutableCopy];
        [tempArr removeObjectAtIndex:index];
        self.midiVoiceArray = tempArr;
        
        tempArr = [self.panArray mutableCopy];
        [tempArr removeObjectAtIndex:index];
        self.panArray = tempArr;
        
        tempArr = [self.volArray mutableCopy];
        [tempArr removeObjectAtIndex:index];
        self.volArray = tempArr;
        
        tempArr = [self.registerArray mutableCopy];
        [tempArr removeObjectAtIndex:index];
        self.registerArray = tempArr;
        
        [self recreateGrid];
    }
}

- (void)modifyAnt:(NSInteger)index startRow:(NSInteger)startRow startCol:(NSInteger)startCol startDir:(NSInteger)startDir {
    NSMutableArray *antsCopy = [self.antsInitialStatus mutableCopy];
    AbstractAnt *ant = antsCopy[index];
    GridPoint *newStart = [[GridPoint alloc] initWithRow:startRow andCol:startCol];
    ant.currentPos = newStart;
    ant.direction = startDir;
    
    self.antsInitialStatus = antsCopy; // TODO determine if nec, should be!
    // recreateGrid will be called when ModifyAntTVC is closed
    
}


#pragma mark - Saving Settings
- (NSDictionary*) createDictFromCurrentSettings {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = self.name;
    dict[antTypeKey] = [NSNumber numberWithInteger:self.antType];
    dict[statesListKey] = self.statesListInGrid;
    dict[numRowsKey] = [NSNumber numberWithInteger:self.numRowsInGrid];
    dict[numColsKey] = [NSNumber numberWithInteger:self.numColsInGrid];
    dict[speedKey] = self.speed;
    dict[shapeKey] = [NSNumber numberWithBool: self.defaultShape];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:self.colorScheme];
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
    
    //music:
    dict[musicScaleKey] = self.scaleName;
    dict[musicIsOnKey] = [NSNumber numberWithBool: self.musicIsOn];
    dict[musicVolArrayKey] = [self.volArray mutableCopy];
    dict[midiVoiceArrayKey] = [self.midiVoiceArray mutableCopy];
    dict[musicTypeArrayKey] = [self.musicTypeArray mutableCopy];
    dict[musicRegisterArrayKey] = [self.registerArray mutableCopy];
    dict[musicLinePanArrayKey] = [self.panArray mutableCopy];
    
    return dict;
}


- (void)saveCurrentSettings {
    NSDictionary *dict = [self createDictFromCurrentSettings];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayOfPresetDicts = [[defaults arrayForKey:userDefaultsPresetDictKey] mutableCopy];
    if (arrayOfPresetDicts == nil) {
        arrayOfPresetDicts = [[NSMutableArray alloc] init];
    }
    [arrayOfPresetDicts addObject:dict];
    [defaults setObject:arrayOfPresetDicts forKey:userDefaultsPresetDictKey];
    [self addPresetDictToPresetStorage:dict];
}

- (BOOL)settingsNameIsAvailable:(NSString*)nameAttempt {
    for (NSString* usedName in self.fourWayPresetNames) {
        if ([nameAttempt isEqualToString:usedName]) {
            return NO;
        }
    }
    for (NSString* usedName in self.sixWayPresetNames) {
        if ([nameAttempt isEqualToString:usedName]) {
            return NO;
        }
    }
    for (NSString* usedName in self.eightWayPresetNames) {
        if ([nameAttempt isEqualToString:usedName]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Preset Unpacking
- (void) buildPresets {
    // negative values for startRow, startCol are flags to set as default
    
    self.eightWayPresetNames = [[NSMutableArray alloc] init];
    self.sixWayPresetNames = [[NSMutableArray alloc] init];
    self.fourWayPresetNames = [[NSMutableArray alloc] init];
    self.presetDictionaries = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"symmetrical hexagon 4-state";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] = @[ @(-1), @(-1), @1, @1];
    dict[numRowsKey] = [NSNumber numberWithInteger: 40];
    dict[numColsKey] = [NSNumber numberWithInteger: 50];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    NSArray *startRows = @[@-1];
    NSArray *startCols = @[@-1];
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
    dict[numColsKey] = [NSNumber numberWithInteger: 50];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:-1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
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
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@10];
    startCols = @[@10];
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
    dict[colorSchemeKey] = [NSNumber numberWithInteger:-1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
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
    NSInteger cols = 240;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"Screen3";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] =  @[@-1,@-2,@0, @3, @-2, @-1,@2];
    
    rows = 200;
    cols = 170;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.01];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"the ring";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
//    L2NNL1L2L1
    dict[statesListKey] =  @[@-2,@0,@0, @-1, @-2, @-1];
    
    rows = 200;
    cols = 240;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.01];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:4];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@50];
    startCols = @[@90];
    startDirections = @[@3];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"horizontal gridmaker";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[ @(3), @(-2), @4, @2, @-3,@1];
    rows = 300;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:-1];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@-1,@-1];
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
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
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
    cols = 50;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:2];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
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
    cols = 40;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"Screen 2";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @1, @1, @-1, @-1];
    rows = 80;
    cols = 40;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.01];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:1];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@10, @11];
    startCols = @[@19, @20];
    startDirections = @[@0, @2];
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
    cols = 240;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:NO];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"expanding triangle (be patient)";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    dict[statesListKey] = @[ @1,@1,@-1, @-1,@-1,@1,@-1, @-1,@-1,@1,@1,@1];
    rows = 150;
    cols = 250;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:NO];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    // don't change:
    startRows = @[@(28)];
    startCols = @[@28];
    startDirections = @[@2]; // was 3
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    
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
    dict[colorSchemeKey] = [NSNumber numberWithInteger:-1];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@-1,@-1];
    startCols = @[@(cols / 2), @(cols / 4)];
    startDirections = @[@0,@1];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"bender";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[ @0,@4,@3];
    rows = 200;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:-1];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"basic 8-way";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[@1,@-1];
    NSLog(@"used -1 as Row val");
    rows = -1;
    cols = 80;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:-1];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"period 13";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[@2,@-2, @1,@-1] ;
    NSLog(@"used -1 as Row val");
    rows = -1;
    cols = 90;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@-1, @-1];
    startCols = @[@(cols / 2), @(cols / 4)];
    startDirections = @[@0,@6];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    dict[musicIsOnKey] = [NSNumber numberWithBool:YES];
    dict[musicScaleKey] = @"stacked3rds";
    dict[musicTypeArrayKey] = @[@YES, @NO];
    dict[musicLinePanArrayKey] = @[@-1, @1];
    dict[musicVolArrayKey] = @[@1, @1];
    dict[musicRegisterArrayKey] = @[@0, @1];
    dict[midiVoiceArrayKey] = @[@108,@108];
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"high period";
    dict[antTypeKey] = [NSNumber numberWithInteger:EIGHT_WAY];
    dict[statesListKey] = @[@3,@3,@3, @0] ;
    rows = 0;
    cols = 50;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0,@1];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"icon";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
    dict[statesListKey] = @[@2,@-1,@2, @2, @2] ;
    rows = 0;
    cols = 20;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@10];
    startCols = @[@6];
    startDirections = @[@0];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"Screen01";
    dict[antTypeKey] = [NSNumber numberWithInteger:SIX_WAY];
      dict[statesListKey] = @[ @2, @-2, @2, @2, @2];
    rows = 0;
    cols = 30;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:8];
    dict[numAntsKey] = [NSNumber numberWithInteger:2];
    startRows = @[@11, @15];
    startCols = @[@16, @12];
    startDirections = @[@0, @3];
    dict[antStartRowsKey] = startRows;
    dict[antStartColsKey] = startCols;
    dict[antDirectionKey] = startDirections;
    
    
    [self addPresetDictToPresetStorage:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    dict[nameKey] = @"fractal 1";
    dict[antTypeKey] = [NSNumber numberWithInteger:FOUR_WAY];
    // lllr lrrr rrrr r
    dict[statesListKey] = @[@-1,@-1,@-1,@1, @-1,@1,@1,@1, @1,@1,@1,@1, @1] ;
    rows = 0;
    cols = 220;
    dict[numRowsKey] = [NSNumber numberWithInteger: rows];
    dict[numColsKey] = [NSNumber numberWithInteger: cols];
    dict[speedKey] = [NSNumber numberWithFloat: 0.02];
    dict[shapeKey] = [NSNumber numberWithBool:YES];
    dict[colorSchemeKey] = [NSNumber numberWithInteger:0];
    dict[numAntsKey] = [NSNumber numberWithInteger:1];
    startRows = @[@-1];
    startCols = @[@-1];
    startDirections = @[@0];
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
    self.presetDictionaries[name] = dict;
}

- (void)getPresetFromNSUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfPresetDicts = [defaults arrayForKey:userDefaultsPresetDictKey];
    if (arrayOfPresetDicts != nil) {
        for (NSDictionary *dict in arrayOfPresetDicts) {
            [self addPresetDictToPresetStorage:dict];
        }
    }
}


#pragma mark - Generating Rule Strings
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


#pragma mark - Colors
+ (NSArray*)masterColorList {
    NSArray *masterList = @[
                            //blue burgandy blue
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"426489" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"9E0331" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"7099A6" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"F4E8C1" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"0199AD" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"1F3243" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"5E031D" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"9AB7C0" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"C4BA9B" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"7ECBD5" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"645E4F" alpha:1.0]],          // c3
                            
                            // blue orange brown
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"2E2E3A" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"FBB034" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"BC5D2E" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"BBB8B2" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"C3340F" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"585862" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"FBE0AC" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"D89D82" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"5C5E58" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"631807" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"E5E2E2" alpha:1.0]],          // c3
                            
                            
                            // pastelly brown green purple
                            @[[UIColor whiteColor],                                 // white
                              [UIColor colorwithHexString:@"FFE8C4" alpha:1.0],           // a1
                              [UIColor colorwithHexString:@"AAA6D0" alpha:1.0],           // b1
                              [UIColor colorwithHexString:@"9CCBBC" alpha:1.0],           // c1
                              [UIColor colorwithHexString:@"FED9A0" alpha:1.0],           // d1
                              [UIColor colorwithHexString:@"7D78B1" alpha:1.0],           // a2
                              [UIColor colorwithHexString:@"69A895" alpha:1.0],           // b2
                              [UIColor colorwithHexString:@"D7AA66" alpha:1.0],           // c2
                              [UIColor colorwithHexString:@"585195" alpha:1.0],           // d2
                              [UIColor colorwithHexString:@"438E77" alpha:1.0],           // a3
                              [UIColor colorwithHexString:@"383178" alpha:1.0],           // b3
                              [UIColor colorwithHexString:@"AD7E36" alpha:1.0]],          // c3
                            
                            // b
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"464A3E" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"A4AC96" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"857F74" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"6A6469" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"A2B37E" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"70726A" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"8C868B" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"A9A69E" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"747969" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"7A875E" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"2C2B2B" alpha:1.0]],          // c3
                            
                            
                            
                            
                            
                            // nice blue purple green in shades
                            @[[UIColor whiteColor],
                              [UIColor colorwithHexString:@"847EB1" alpha:1.0],           // c1
                              [UIColor colorwithHexString:@"7CBB92" alpha:1.0],           // d1
                              [UIColor colorwithHexString:@"D890AF" alpha:1.0],           // a2
                              [UIColor colorwithHexString:@"5B5393" alpha:1.0],           // b2
                              [UIColor colorwithHexString:@"4E9C68" alpha:1.0],           // c2
                              [UIColor colorwithHexString:@"B45A81" alpha:1.0],
                              [UIColor colorwithHexString:@"3A3276" alpha:1.0],
                              [UIColor colorwithHexString:@"297C46" alpha:1.0],           // a1
                              [UIColor colorwithHexString:@"90305A" alpha:1.0],  // d2
                              [UIColor colorwithHexString:@"201858" alpha:1.0],           // a3
                              [UIColor colorwithHexString:@"105D2A" alpha:1.0]],           // b3
                            
                            
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"713E5A" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"63A375" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"EDC79B" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"D57A66" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"CA6680" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"9B778D" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"93BE9F" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"F7E5CD" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"E1A193" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"D993A7" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"75634B" alpha:1.0]],          // c3
                            
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"F6511D" alpha:1.0],          // c2
                               [UIColor colorwithHexString:@"0D2C54" alpha:1.0],
                               [UIColor colorwithHexString:@"FFB400" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"7FB800" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"00A6ED" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"FA9579" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"6D8098" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"976C00" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"4B7000" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"00628D" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"F98462" alpha:1.0],          // c3
                               [UIColor colorwithHexString:@"68CAF5" alpha:1.0]],          // c3
                            
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"725752" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"878E8" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"96C0B7" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"D4DFC7" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"FEF6C9" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"3B2A2A" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"C3C5C4" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"5A746F" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"959D8B" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"817965" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"9C8A85" alpha:1.0],          // c3
                               ],          // c3
                            
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"A6808C" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"D6CFCB" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"706677" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"CCB7AE" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"292A32" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"624C54" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"827B7B" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"443E47" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"7C6F6A" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"BCB8C4" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"C1A7B0" alpha:1.0],          // c3
                               ],
                            // c3
                            @[ [UIColor whiteColor],         // white
                               [UIColor colorwithHexString:@"824670" alpha:1.0],           // a1
                               
                               [UIColor colorwithHexString:@"C3D2D5" alpha:1.0],           // a1
                               [UIColor colorwithHexString:@"BDA0BC" alpha:1.0],           // b1
                               [UIColor colorwithHexString:@"DDD78D" alpha:1.0],           // c1
                               [UIColor colorwithHexString:@"A2708A" alpha:1.0],           // d1
                               [UIColor colorwithHexString:@"412339" alpha:1.0],           // a2
                               [UIColor colorwithHexString:@"5F696C" alpha:1.0],           // b2
                               [UIColor colorwithHexString:@"5E505D" alpha:1.0],           // c2
                               [UIColor colorwithHexString:@"857F55" alpha:1.0],           // d2
                               [UIColor colorwithHexString:@"422E36" alpha:1.0],           // a3
                               [UIColor colorwithHexString:@"9BA8AB" alpha:1.0],           // b3
                               [UIColor colorwithHexString:@"E9E7B9" alpha:1.0],          // c3
                               ],
                            
                            ];
    
    return masterList;
}


@end
