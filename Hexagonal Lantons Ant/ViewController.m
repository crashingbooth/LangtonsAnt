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
NSArray *clr;
NSMutableArray *gridOfViews;
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
     clr  = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
   
    [self makeSquareGrid];
//    hgv.backgroundColor = [UIColor clearColor];
//    [hgv createRects];
//    [self.view addSubview:hgv];
    
    // 1st ant:
//    AbstractAnt *ant = [[FourWayAnt alloc] initWithDirection:0 atPos:startPoint maxRow:rows maxCol:cols];
//    MusicInterpretter *musInt1 = [[MusicInterpretter alloc] initWithRootNote:@60 withScale:@"pelang" onChannel:@0 withMidi:mid] ;
//    [ant addMusicInterpretter:musInt1];
    [grid addAnt:ant];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    [grid update];
//    NSArray *ants = grid.ants;
    for (AbstractAnt *ant in grid.ants) {
        
        
//        NSLog([NSString stringWithFormat:@"%i, %i", cell.row, cell.col]);
        UIView *changedTile = [[gridOfViews objectAtIndex: ant.currentPos.row ] objectAtIndex:ant.currentPos.col];
        NSInteger newState = [[[grid.matrix objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col] integerValue];
//         NSLog([NSString stringWithFormat:@"%i, %i, %li", cell.row, cell.col, newState]);
        changedTile.backgroundColor = [clr objectAtIndex:newState];
    }
    
}

-(void)makeSquareGrid {
    ant = [[FourWayAnt alloc] initWithDirection:RIGHT_4 atPos:startPoint maxRow:rows maxCol:cols];
    gridOfViews = [[NSMutableArray alloc] init];
    for (int row = 0; row < rows; row++) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < cols; col++) {
            CGRect rect = CGRectMake((CGFloat)col * gridWidth, (CGFloat)row * gridWidth, gridWidth, gridWidth);
            UIView *cell = [[UIView alloc] initWithFrame:rect];
            cell.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:cell];
            [currentRow addObject:cell];
        }
        [gridOfViews addObject:currentRow];
    }
}

-(void)makeHexGrid {
    hgv = [[HexagonalGridView alloc] initWithWidth:gridWidth andFrame:self.view.frame andGrid:grid];
    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT_4 atPos:startPoint maxRow:rows maxCol:cols];
}









@end
