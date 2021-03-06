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
#import "AbstractMusicLine.h"

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
TimedLoop *loop;


@synthesize currentState = _currentState;

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayOrHideSettingsButtonAndLabel];
    
    loop = [[TimedLoop alloc] initWithDuration:0.5];
    loop.delegate = self;
    
   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    settings = [Settings sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    // use this ratio when choosing custom widths
    if ([Settings sharedInstance].lengthToWidthRatio == 0.0 ) {
        [[Settings sharedInstance] establishLengthToWidthRatio:self.view.frame.size.width length:self.view.frame.size.height];
        [Settings sharedInstance].needToRebuild = YES;
    }
    if ([Settings sharedInstance].name == nil) {
        NSLog(@"unset");
        [[Settings sharedInstance] extractSettingsFromDict: [Settings sharedInstance].presetDictionaries[[[Settings sharedInstance] randomStartingPreset]]];
        
    }
    _settingsButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _countLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.navigationController setNavigationBarHidden:YES];
    [self rebuildGridCollectionIfNecessary];
    [loop startLoop];
//    self.currentState = PAUSED;
}

- (void) loopBody {
    NSLog(@"hi im loop body!");
    if (_currentState == PAUSED) {
        [loop stopLoop];
    } else {
        [gridColl updateViews];
    }

}




#pragma mark CurrentState and Update

- (void)update:(NSTimer*)timer {
//    if (settings.settingsGrid.count == 81754) {
//        _currentState = PAUSED;
//    }
       if (_currentState == PAUSED) {
        [timer invalidate];
    } else {
         [gridColl updateViews];
    }
   
}

- (void)setCurrentState:(CurrentState)currentState {
    _currentState = currentState;
    [self displayOrHideSettingsButtonAndLabel];
    if (currentState == ACTIVE) {
        double dur = [settings.speed doubleValue];
        [loop getTriggerFromDuration:dur];
        [loop startLoop];
        NSLog(@"should start");
//         [NSTimer scheduledTimerWithTimeInterval:[settings.speed floatValue]  target:self selector:@selector(update:) userInfo:nil repeats:YES];
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
        _countLabel.text = [ NSString stringWithFormat:@"Count: %li (tap screen to restart)",  (unsigned long)settings.settingsGrid.count ];
    }
}

- (void)routeChanged:(NSNotification*)notification {
    self.currentState = PAUSED;
}

#pragma mark Building and Rebuilding

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
        if (settings.musicIsOn) {
            [settings updateMusicStatusOfAnts]; //new
        }
        settings.needToRebuild = NO;
        
    }
    
}



@end
