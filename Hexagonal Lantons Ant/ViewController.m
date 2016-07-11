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
#import "Grid.h"
#import "HexagonalAnt.h"
#import "AbstractAnt.h"
#import "FourWayAnt.h"
#import "MidiNote.h"
#import "MusicInterpretter.h"

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
//    MidiNote *mid = [[MidiNote alloc] init ];
   
    rows = 50;
    cols = 50;
    
    gridWidth = round(self.view.frame.size.width / cols);
    states = @[@-1, @-1,@1,@1];
    grid = [[Grid alloc] initWithRows:rows  andCols:cols andStates:states];
    startPoint = [[GridPoint alloc] initWithRow:rows / 2 - 1 andCol:cols / 2 - 1] ;
    [grid buildZeroStateMatrix];

   
    [self makeSquareGrid];

    // 1st ant:
//    AbstractAnt *ant = [[FourWayAnt alloc] initWithDirection:0 atPos:startPoint maxRow:rows maxCol:cols];
//    MusicInterpretter *musInt1 = [[MusicInterpretter alloc] initWithRootNote:@60 withScale:@"pelang" onChannel:@0 withMidi:mid] ;
//    [ant addMusicInterpretter:musInt1];
    [grid addAnt:ant];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    [gridColl updateViews];
}

-(void)makeSquareGrid {
    ant = [[FourWayAnt alloc] initWithDirection:RIGHT_4 atPos:startPoint maxRow:rows maxCol:cols];
    gridColl = [[SquareGridCollection alloc] initWithParentView:self.view grid:grid boxSize:gridWidth];
    
}

-(void)makeHexGrid {
//    hgv = [[HexagonalGridView alloc] initWithWidth:gridWidth andFrame:self.view.frame andGrid:grid];
//    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT_4 atPos:startPoint maxRow:rows maxCol:cols];
}









@end
