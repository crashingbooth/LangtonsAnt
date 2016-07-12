//
//  ViewController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController ()

@end

@implementation ViewController
AbstractAnt *ant;
Grid *grid;
AbstractGridCollection *gridColl;
NSArray *states;
NSUInteger count;
NSUInteger rows;
NSUInteger cols;
CGFloat gridWidth;
GridPoint *startPoint;
- (void)viewDidLoad {
    [super viewDidLoad];
    MidiNote *mid = [[MidiNote alloc] init ];
   
    rows = 40;
    cols = 30;
    // 60 40  good
    gridWidth = round(self.view.frame.size.width / cols);
    states = @[@2,@-2, @1,@-1];
//    states = @[@3,@-2,@4, @2, @-3];
    grid = [[Grid alloc] initWithRows:rows  andCols:cols andStates:states];
    startPoint = [[GridPoint alloc] initWithRow:rows / 2 - 1 andCol:cols / 2 - 1] ;
    
   
    
    [grid buildZeroStateMatrix];

   
    [self makeSquareGrid];

    // 1st ant:
//    AbstractAnt *ant = [[FourWayAnt alloc] initWithDirection:0 atPos:startPoint maxRow:rows maxCol:cols];
    MusicInterpretter *musInt1 = [[MusicInterpretter alloc] initWithRootNote:@60 withScale:@"pentatonic" onChannel:@0 withMidi:mid] ;
    [ant addMusicInterpretter:musInt1];
    [grid addAnt:ant];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    [gridColl updateViews];
}

-(void)makeSquareGrid {
    ant = [[EightWayAnt alloc] initWithDirection:RIGHT_8 atPos:startPoint maxRow:rows maxCol:cols];
    gridColl = [[SquareGridCollection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:YES];
    
}

-(void)makeHexGrid {
    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT atPos:startPoint maxRow:rows maxCol:cols];
    gridColl = [[HexagonGridColection alloc] initWithParentView:self.view grid:grid boxWidth:gridWidth drawAsCircle:YES];
}









@end
