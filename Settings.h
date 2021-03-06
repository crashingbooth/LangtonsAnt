//
//  Settings.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+UIColorFromHex.h"
#import "Constants.h"
#import "AbstractAnt.h"
#import "FourWayAnt.h"
#import "EightWayAnt.h"
#import "GridPoint.h"
#import "Grid.h"
#import "MusicInterpretter.h"
#import "DrumPlayerLine.h"
#import "MidiLine.h"


@interface Settings : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) AntType antType;
@property (nonatomic) NSInteger numStates;
@property (nonatomic, strong) NSArray *statesListInGrid;
@property (nonatomic) NSInteger numRowsInGrid;
@property (nonatomic) NSInteger numColsInGrid;
@property (nonatomic, strong) NSArray *colorList;
@property (nonatomic, copy) NSArray *antsInitialStatus;
@property (nonatomic) NSInteger numAnts;
@property (nonatomic) Grid *settingsGrid;
@property (nonatomic) NSNumber *speed;
@property (nonatomic) BOOL defaultShape;
@property (nonatomic) NSInteger colorScheme;

@property (nonatomic) BOOL musicIsOn;
@property (nonatomic) NSString *scaleName;
@property (nonatomic) NSMutableArray *musicTypeArray;
@property (nonatomic) NSMutableArray *midiVoiceArray;
@property (nonatomic) NSMutableArray *panArray;
@property (nonatomic) NSMutableArray *volArray;
@property (nonatomic) NSMutableArray *registerArray;

@property (nonatomic) BOOL needToRebuild;
@property (nonatomic) NSMutableArray *eightWayPresetNames;
@property (nonatomic) NSMutableArray *sixWayPresetNames;
@property (nonatomic) NSMutableArray *fourWayPresetNames;
@property (nonatomic) NSMutableDictionary *presetDictionaries;
@property (nonatomic) CGFloat lengthToWidthRatio;


+ (Settings *)sharedInstance;
+ (NSArray*)masterColorList;
- (NSDictionary*) createDictFromCurrentSettings ;
- (void) extractSettingsFromDict: (NSDictionary*) dict;
- (NSString*)getStateName:(NSInteger)stateNumber forAntType:(AntType)type;
- (void)establishLengthToWidthRatio:(CGFloat)width length:(CGFloat)length;
- (NSInteger)getAppropriateNumberOfRowsForScreen:(NSInteger)numCols;
- (NSString*)getRuleSystemAsString;
- (NSString*)getFullDescription;
- (NSString*)getFullDescription:(NSDictionary*)dictWithCorrectAntNum;
- (NSArray*)assignColorScheme:(NSInteger)colorIndex;
- (void)recreateGrid;
- (void)addState;
- (void)addAnt;
- (void)removeAnt:(NSInteger)index;
- (void)modifyAnt:(NSInteger)index startRow:(NSInteger)startRow startCol:(NSInteger)startCol startDir:(NSInteger)startDir;
- (void)saveCurrentSettings;
- (BOOL)settingsNameIsAvailable:(NSString*)nameAttempt;
- (NSString*)randomStartingPreset;
- (void) updateMusicStatusOfAnts;

// to be called from AppDelegate:
- (void)buildPresets;
- (void)getPresetFromNSUserDefaults;
@end
