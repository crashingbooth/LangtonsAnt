//
//  ViewController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ViewController.h"
#import "HexagonalGridView.h"
#import "Grid.h"
#import "HexagonalAnt.h"
#import "AbstractAnt.h"
#import "MidiNote.h"
#import "MusicInterpretter.h"

@interface ViewController ()

@end

@implementation ViewController
HexagonalGridView *hgv;
HexagonalAnt *ant;
HexagonalAnt *ant2;
NSUInteger count;
- (void)viewDidLoad {
    [super viewDidLoad];
    MidiNote *mid = [[MidiNote alloc] init ];
   
    
    NSUInteger numRows = 70;
    NSUInteger numCols = 70;
    
    CGFloat shapeWidth = self.view.frame.size.width / numCols;

    Grid *grid = [[Grid alloc] initWithRows:numRows  andCols:numCols andStates:5];
    NSArray *states = @[@2, @-2,@2, @2, @-3];
    [grid setStates: states];
    [grid buildZeroStateMatrix];
    hgv = [[HexagonalGridView alloc] initWithWidth:shapeWidth andFrame:self.view.frame andGrid:grid];
    hgv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hgv];

    GridPoint *start = [[GridPoint alloc] initWithRow:numRows / 4  andCol:numCols / 2] ;
     GridPoint *start2 = [[GridPoint alloc] initWithRow:numRows / 4 * 3  andCol:numCols / 2] ;
    
  
    
    MusicInterpretter *musInt1 = [[MusicInterpretter alloc] initWithRootNote:@60 withScale:@"pelang" onChannel:@0 withMidi:mid] ;
    MusicInterpretter *musInt2 = [[MusicInterpretter alloc] initWithRootNote:@72 withScale:@"pelang" onChannel:@1 withMidi:mid] ;
    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT atPos:start maxRow:numRows maxCol:numCols];
    [ant addMusicInterpretter:musInt1];
    
    ant2 = [[HexagonalAnt alloc] initWithDirection:DOWN_RIGHT atPos:start2 maxRow:numRows maxCol:numCols];
    [ant2 addMusicInterpretter:musInt2];
    [grid addAnt:ant atRow:5 andCol:5];
    [grid addAnt:ant2 atRow:5 andCol:5];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    //    NSLog(@"updated");
    count++;
    [hgv.grid update];
    [hgv setNeedsDisplay];
//    [hgv updateOnlyAntRect];
//     NSLog([NSString stringWithFormat:@" dir adjust: %li", count]);
    


}



@end
