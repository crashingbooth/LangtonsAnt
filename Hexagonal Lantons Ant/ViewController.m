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
NSUInteger count;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUInteger numRows = 70;
    NSUInteger numCols = 70;
    
    CGFloat shapeWidth = self.view.frame.size.width / numCols;

    Grid *grid = [[Grid alloc] initWithRows:numRows  andCols:numCols andStates:3];
    NSArray *states = @[@-1, @2, @-1];
    [grid setStates: states];
    [grid buildZeroStateMatrix];
    hgv = [[HexagonalGridView alloc] initWithWidth:shapeWidth andFrame:self.view.frame andGrid:grid];
    hgv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hgv];
//    [hgv setNeedsDisplay];
    GridPoint *start = [[GridPoint alloc] initWithRow:numRows / 2 andCol:numCols / 2] ;

//    ant = [[HexagonalAnt alloc] initWithDirection:RIGHT atPos:start maxRow:numRows maxCol:numCols];
    ant = [[HexagonalAnt alloc] initWithDirection:LEFT atPos:start maxRow:numRows maxCol:numCols];
    [grid addAnt:ant atRow:5 andCol:5];
    [grid update];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(NSTimer*)timer {
    //    NSLog(@"updated");
    count++;
    [hgv.grid update];
    [hgv setNeedsDisplay];
//    [hgv updateOnlyAntRect];
     NSLog([NSString stringWithFormat:@" dir adjust: %li", count]);
    


}



@end
