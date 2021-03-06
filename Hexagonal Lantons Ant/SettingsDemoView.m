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
NSTimer *myTimer;
NSMutableDictionary *dict;

- (void)setUpWithSettingsDict:(NSMutableDictionary*) originalDict{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanUp:) name:@"loadSettingsNeedsCleanUp" object:nil];
    
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
    self.dict[musicIsOnKey] = [NSNumber numberWithBool:NO];
    
    
    [self.demo extractSettingsFromDict:self.dict];
    for (AbstractAnt *ant in self.demo.settingsGrid.ants) {
        ant.silent = YES;
    }
    originalAnt = [self.demo.antsInitialStatus[0] copyWithZone:nil];
    widthOfShape = self.frame.size.width / [size floatValue];
    [self.demo.settingsGrid buildZeroStateMatrix];
    
    
    NSArray* colorList = self.demo.colorList;
    switch (self.demo.antType) {
        case FOUR_WAY:
            self.demoGrid = [[SquareGridCollection alloc] initWithParentView:self grid:self.demo.settingsGrid boxWidth:widthOfShape drawAsCircle:self.demo.defaultShape colorList:colorList];
            break;
        case SIX_WAY:
            self.demoGrid = [[HexagonGridColection alloc] initWithParentView:self grid:self.demo.settingsGrid boxWidth:widthOfShape drawAsCircle:NO colorList:colorList];
            break;
        case EIGHT_WAY:
            self.demoGrid = [[SquareGridCollection alloc] initWithParentView:self grid:self.demo.settingsGrid boxWidth:widthOfShape drawAsCircle:self.demo.defaultShape colorList:colorList
                             ];
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
    if (originalAnt != nil) {
        NSArray *newAnt = @[[originalAnt copyWithZone:nil]];
        demo.settingsGrid.ants = [newAnt mutableCopy];
    }
    [demo.settingsGrid buildZeroStateMatrix];
    [demoGrid cleanGrid];
}

- (void)animate:(NSTimeInterval)timeInterval {
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)cleanUp:(NSNotification*)msg {
    [myTimer invalidate];
    self.demo = nil;
    [self.demoGrid removeAllViews];
    self.demoGrid = nil;
    self.dict = nil;
    [self removeFromSuperview];
    // delete settings etc
    
}



@end
