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

@interface ViewController ()

@end

@implementation ViewController
HexagonalGridView *hgv;
HexagonalAnt *ant;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUInteger numRows = 51;
    NSUInteger numCols = 51;
    
    CGFloat shapeWidth = self.view.frame.size.width / numCols;

    Grid *grid = [[Grid alloc] initWithRows:numRows  andCols:numCols andStates:2];
    NSArray *states = @[@0, @1];
    [grid setStates: states];
    [grid buildZeroStateMatrix];
    hgv = [[HexagonalGridView alloc] initWithWidth:shapeWidth andFrame:self.view.frame andGrid:grid];
    hgv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hgv];
//    [hgv setNeedsDisplay];
    GridPoint start;
    start.col = numCols / 2;
    start.row = numRows / 2;
//    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT_STRAIGHT atPos:start maxRow:numRows maxCol:numCols];
    ant = [[HexagonalAnt alloc] initWithDirection:UP_LEFT atPos:start maxRow:numRows maxCol:numCols];
    [grid addAnt:ant atRow:5 andCol:5];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    //    NSLog(@"updated");
    [hgv.grid update];
    [hgv setNeedsDisplay];
    


}



@end
