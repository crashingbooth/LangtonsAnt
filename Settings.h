//
//  Settings.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AbstractAnt.h"
#import "FourWayAnt.h"
#import "GridPoint.h"
#import "Grid.h"


@interface Settings : NSObject
@property (nonatomic) AntType antType;
@property (nonatomic) NSInteger numStates;
@property (nonatomic, strong) NSArray *statesListInGrid;
@property (nonatomic) NSInteger numRowsInGrid;
@property (nonatomic) NSInteger numColsInGrid;
@property (nonatomic, strong) NSArray *colorList;
@property (nonatomic, strong) NSArray *antsInitialStatus;
@property (nonatomic) NSInteger numAnts;
@property (nonatomic, strong) Grid *settingsGrid;


+ (Settings *)sharedInstance;
@end
