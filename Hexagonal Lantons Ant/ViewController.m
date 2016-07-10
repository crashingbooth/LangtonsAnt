//
//  ViewController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ViewController.h"
#import "HexagonalGridView.h"
#import "AntGridView.h"
#import "Grid.h"
#import "HexagonalAnt.h"
#import "AbstractAnt.h"
#import "FourWayAnt.h"
#import "MidiNote.h"
#import "MusicInterpretter.h"

@interface ViewController ()

@end

@implementation ViewController
AntGridView *hgv;
AbstractAnt *ant;
HexagonalAnt *ant2;
Grid *grid;
NSArray *states;
NSUInteger count;
NSUInteger rows;
NSUInteger cols;
CGFloat gridWidth;
GridPoint *startPoint;
- (void)viewDidLoad {
    [super viewDidLoad];
    MidiNote *mid = [[MidiNote alloc] init ];
   
    rows = 20;
    cols = 20;
    
    gridWidth = round(self.view.frame.size.width / cols);
    states = @[@-1, @-1,@1,@1];
    grid = [[Grid alloc] initWithRows:rows  andCols:cols andStates:states];
    startPoint = [[GridPoint alloc] initWithRow:rows / 2 - 1 andCol:cols / 2 - 1] ;
    [grid buildZeroStateMatrix];
   
    [self makeSquareGrid];
    hgv.backgroundColor = [UIColor clearColor];
    [hgv createRects];
    [self.view addSubview:hgv];
    
    // 1st ant:

//    MusicInterpretter *musInt1 = [[MusicInterpretter alloc] initWithRootNote:@60 withScale:@"pelang" onChannel:@0 withMidi:mid] ;
//    [ant addMusicInterpretter:musInt1];
    [grid addAnt:ant];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    count++;
        [hgv.grid update];
//    [hgv setNeedsDisplay];
    [hgv updateOnlyAntRect];
//     NSLog([NSString stringWithFormat:@" dir adjust: %li", count]);
    
}

-(void)makeSquareGrid {
    hgv = [[AntGridView alloc] initWithWidth:gridWidth andFrame:self.view.frame andGrid:grid];
    ant = [[FourWayAnt alloc] initWithDirection:RIGHT_4 atPos:startPoint maxRow:rows maxCol:cols];
}

-(void)makeHexGrid {
    hgv = [[HexagonalGridView alloc] initWithWidth:gridWidth andFrame:self.view.frame andGrid:grid];
    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT_4 atPos:startPoint maxRow:rows maxCol:cols];
}







@end
