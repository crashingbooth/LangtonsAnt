//
//  MainDisplayViewController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

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
@synthesize currentState = _currentState;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayOrHideSettingsButton];
    
    settings = [Settings sharedInstance];
//    [self rebuildGridCollectionIfNecessary];
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

- (void)viewWillAppear:(BOOL)animated {
    // use this ratio when choosing custom widths
    if ([Settings sharedInstance].lengthToWidthRatio == 0.0 ) {
        [[Settings sharedInstance] establishLengthToWidthRatio:self.view.frame.size.width length:self.view.frame.size.height];
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self rebuildGridCollectionIfNecessary];
}

- (void)update:(NSTimer*)timer {
    if (_currentState == PAUSED) {
        [timer invalidate];
    } else {
         [gridColl updateViews];
    }
   
}

- (void)setCurrentState:(CurrentState)currentState {
    _currentState = currentState;
    [self displayOrHideSettingsButton];
    if (currentState == ACTIVE) {
         [NSTimer scheduledTimerWithTimeInterval:[settings.speed floatValue]  target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
}

- (void)makeGridCollection {
    switch (settings.antType) {
        case FOUR_WAY:
            gridColl = [[SquareGridCollection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:settings.defaultShape];
            break;
        case SIX_WAY:
            gridColl = [[HexagonGridColection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:NO];
            break;
        case EIGHT_WAY:
            gridColl = [[SquareGridCollection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:settings.defaultShape];
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


- (void)displayOrHideSettingsButton {
    if (_currentState == ACTIVE) {
        _settingsButton.enabled = NO;
        _settingsButton.alpha = 0;
        
    } else {
        _settingsButton.enabled = YES;
        _settingsButton.alpha = 1.0;
        [self.view bringSubviewToFront:_settingsButton];
    }
}



@end
