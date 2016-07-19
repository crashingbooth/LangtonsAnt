//
//  SettingsDemoView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/18/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "SettingsDemoView.h"
#import "GridPoint.h"
#import "AbstractAnt.h"
#import "SquareGridCollection.h"
#import "HexagonGridColection.h"

@implementation SettingsDemoView
CGFloat widthOfShape;
AbstractGridCollection *demoGrid;
AbstractAnt *originalAnt;
Settings *demo;
NSMutableDictionary *dict;

static NSString *const nameKey = @"name";
static NSString *const antTypeKey = @"antType";
static NSString *const statesListKey = @"statesList"; // Array of NSInteger
static NSString *const numRowsKey = @"numRows";
static NSString *const numColsKey = @"numCols";
static NSString *const speedKey = @"speed";
static NSString *const numAntsKey = @"numAnts";
static NSString *const antDirectionKey = @"antDirections"; // Array of NSInteger
static NSString *const antStartRowsKey = @"antStartRows"; // Array of NSInteger
static NSString *const antStartColsKey = @"antStartCows"; // Array of NSInteger

- (void)setUpWithSettingsDict:(NSMutableDictionary*) originalDict{
    // COPY THE DICT FIRST!!!!!!!!!
    
    self.demo =  [[Settings alloc] init];
    NSNumber *size = @20;
    self.dict = [originalDict mutableCopy];
    self.dict[numRowsKey] = size;
    self.dict[numColsKey] = size;
    NSMutableArray *antStart = [[NSMutableArray alloc] init];
    [antStart addObject: [NSNumber numberWithInteger:([size integerValue] / 2)]];
    self.dict[antStartRowsKey] = antStart;
    self.dict[antStartColsKey] = antStart;
    self.dict[numAntsKey] = @1;
    
    [self.demo extractSettingsFromDict:self.dict];
    NSLog(@"about to copy");
    originalAnt = [self.demo.antsInitialStatus[0] copyWithZone:nil];
    widthOfShape = self.frame.size.width / [size floatValue];
    [self.demo.settingsGrid buildZeroStateMatrix];
    
    switch (demo.antType) {
        case FOUR_WAY:
            self.demoGrid = [[SquareGridCollection alloc] initWithParentView:self grid:self.demo.settingsGrid boxWidth:widthOfShape drawAsCircle:YES];
            break;
        case SIX_WAY:
            self.demoGrid = [[HexagonGridColection alloc] initWithParentView:self grid:self.demo.settingsGrid boxWidth:widthOfShape drawAsCircle:NO];
            break;
        case EIGHT_WAY:
            self.demoGrid = [[SquareGridCollection alloc] initWithParentView:self grid:self.demo.settingsGrid boxWidth:widthOfShape drawAsCircle:YES];
            break;
        default:
            break;
    }
    [self.demo.settingsGrid update];
    
}

- (void) update:(NSTimer*)timer {
    [self.demoGrid updateViews];
}

- (void) reset {
    NSMutableArray *newAnt = @[[originalAnt copyWithZone:nil]];
    demo.settingsGrid.ants = newAnt;
    [demo.settingsGrid buildZeroStateMatrix];
    [demoGrid cleanGrid];
}

- (void)animate:(NSTimeInterval)timeInterval {
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(update:) userInfo:nil repeats:YES];
}



@end
