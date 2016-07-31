//
//  MainDisplayViewController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "MainDisplayViewController.h"
#import "Settings.h"
#import "AbstractGridCollection.h"
#import "SquareGridCollection.h"
#import "HexagonGridColection.h"
#import "Grid.h"
#import "HexagonalAnt.h"
#import "AbstractAnt.h"
#import "FourWayAnt.h"
#import "EightWayAnt.h"
#import "MidiNote.h"
#import "MusicInterpretter.h"
#import "UIViewWithPath.h"


@interface MainDisplayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@end

@implementation MainDisplayViewController
AbstractAnt *ant;
Grid *grid;
AbstractGridCollection *gridColl;
CGFloat gridWidth;
Settings *settings;
CMMotionManager *uMM;
NSNumber *actualDeviceOrientation;
BOOL isPortrait;
BOOL orientationLocked;

@synthesize currentState = _currentState;


- (void)viewDidLoad {
    [super viewDidLoad];
    uMM = [[CMMotionManager alloc] init];
    uMM.accelerometerUpdateInterval = 0.2;
    [uMM startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    
    
    [self displayOrHideSettingsButtonAndLabel];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
        name:UIDeviceOrientationDidChangeNotification
        object:[UIDevice currentDevice]];
    settings = [Settings sharedInstance];
//    [self rebuildGridCollectionIfNecessary];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    if (fabsf(acceleration.y) < fabsf(acceleration.x)) {
        // landscape
        if (acceleration.x > 0) {
            // right
            actualDeviceOrientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        } else {
            // left
            actualDeviceOrientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        }
    } else {
        // portrait
        if (acceleration.y > 0) {
            // down
            actualDeviceOrientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        } else {
            // up
            actualDeviceOrientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];

        }
    }
    NSLog(@"actual orientation %@", actualDeviceOrientation);
    
  
  
    
}



- (void)rebuildGridCollectionIfNecessary{
    if (settings.needToRebuild) {
        [gridColl removeAllViews];
        gridWidth = self.view.frame.size.width / settings.numColsInGrid;
        grid = settings.settingsGrid;
        [grid buildZeroStateMatrix];
        [self makeGridCollection];
        [self.view bringSubviewToFront:_settingsButton];
        
        [grid update];
        [self setCurrentState:ACTIVE];
        settings.needToRebuild = NO;
        
    }
    
}

- (BOOL)shouldAutorotate {
    return !orientationLocked;
}

- (BOOL) currentlyPortait{
    return self.view.frame.size.height > self.view.frame.size.width;
}


- (void)viewWillDisappear:(BOOL)animated {
    orientationLocked = NO;
    NSLog(@"actual orientation %@", actualDeviceOrientation);
    [[UIDevice currentDevice] setValue:actualDeviceOrientation forKey:@"orientation"];
}

- (void)viewWillAppear:(BOOL)animated {
    // use this ratio when choosing custom widths
    self.isPortrait = [self currentlyPortait];
    orientationLocked = YES;
    if ([Settings sharedInstance].lengthToWidthRatio == 0.0 ) {
        [[Settings sharedInstance] establishLengthToWidthRatio:self.view.frame.size.width length:self.view.frame.size.height];
        [Settings sharedInstance].needToRebuild = YES;
    }
    if ([Settings sharedInstance].name == nil) {
        NSLog(@"unset");
        [[Settings sharedInstance] extractSettingsFromDict: [Settings sharedInstance].presetDictionaries[[[Settings sharedInstance] randomStartingPreset]]];
    }
    _settingsButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    _countLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self.navigationController setNavigationBarHidden:YES];
    [self rebuildGridCollectionIfNecessary];
}


- (void)orientationChanged:(NSNotification*) notificiation {
    if (self.isPortrait != [self currentlyPortait]) {
        NSLog(@"change");
    }
}



- (void)update:(NSTimer*)timer {
    if (_currentState == PAUSED) {
        [timer invalidate];
    } else {
         [gridColl updateViews];
        /// HERER!!!
        if ([Settings sharedInstance].settingsGrid.count == 747 || [Settings sharedInstance].settingsGrid.count == 645) {
            _currentState = PAUSED;
        }
    }
   
}

- (void)setCurrentState:(CurrentState)currentState {
    _currentState = currentState;
    [self displayOrHideSettingsButtonAndLabel];
    if (currentState == ACTIVE) {
         [NSTimer scheduledTimerWithTimeInterval:[settings.speed floatValue]  target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
}

- (void)makeGridCollection {
    NSArray* colorList = [Settings sharedInstance].colorList;
    switch (settings.antType) {
        case FOUR_WAY:
            gridColl = [[SquareGridCollection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:settings.defaultShape colorList:colorList];
            break;
        case SIX_WAY:
            gridColl = [[HexagonGridColection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:NO colorList:colorList];
            break;
        case EIGHT_WAY:
            gridColl = [[SquareGridCollection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:settings.defaultShape colorList:colorList];
            break;
        default:
            break;
    }
}

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    if (_currentState == ACTIVE) {
        [self setCurrentState:PAUSED];
    } else if (_currentState == PAUSED) {
        [self setCurrentState:ACTIVE];
    }
}


- (void)displayOrHideSettingsButtonAndLabel {
    if (_currentState == ACTIVE) {
        _settingsButton.enabled = NO;
        _settingsButton.alpha = 0;
        _countLabel.alpha = 0;
        
    } else {
        _settingsButton.enabled = YES;
        _settingsButton.alpha = 1.0;
        [self.view bringSubviewToFront:_settingsButton];
        _countLabel.alpha = 1.0;
        [self.view bringSubviewToFront:_countLabel];
        _countLabel.text = [ NSString stringWithFormat:@"Count: %li (tap screen to restart)",  settings.settingsGrid.count ];
    }
}



@end
