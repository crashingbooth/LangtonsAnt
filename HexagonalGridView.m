//
//  HexagonalGridView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "HexagonalGridView.h"
#import "Grid.h"
#import "AbstractAnt.h"

@implementation HexagonalGridView

CGFloat sideHeight;
CGFloat shapeWidth;
NSMutableArray *paths;
BOOL initialized;


NSArray *colours;

-(id) initWithWidth:(CGFloat) shapeWidth andFrame:(CGRect)frame andGrid:(Grid*)grid {
    NSArray *clr  = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
    self.colours = clr;
    self = [super initWithFrame:frame];
    if (self) {
        self.sideHeight = shapeWidth * 0.57735;
        self.shapeWidth = shapeWidth;
        self.grid = grid;
        paths = [[NSMutableArray alloc] init ];
        initialized = NO;
     
         NSLog([NSString stringWithFormat:@"shapewidth: %.3f, height %.3f", self.shapeWidth, self.sideHeight]);
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    NSLog(@"DRAWRECT");
    if (initialized) {
        for (int row = 0; row < self.grid.matrix.count; row++) {
            NSMutableArray *currentRow = [self.grid.matrix objectAtIndex:row];
            for (int col = 0; col < currentRow.count; col++) {
                NSUInteger state = [[[self.grid.matrix objectAtIndex:row] objectAtIndex: col] integerValue];
                UIBezierPath *path = [self getPathAtRow:row andCol:col];
                
                
                
                UIColor *currentCol = [[self.colours objectAtIndex: state] colorWithAlphaComponent:0.8];
                [currentCol setFill];
//                [[UIColor lightGrayColor] setStroke ];
                
                
                [path fill];
//                [path stroke];
                
                
            }
        }
        initialized = YES;
    } else {
        for (AbstractAnt *ant in self.grid.ants) {
            NSUInteger state = [[[self.grid.matrix objectAtIndex:ant.currentPos.row ] objectAtIndex: ant.currentPos.col] integerValue];
            UIBezierPath *path = [self getPathAtRow:ant.currentPos.row  andCol:ant.currentPos.col];
            UIColor *currentCol = [[self.colours objectAtIndex: state] colorWithAlphaComponent:0.5];
            [currentCol setFill];
            [path fill];
        }
    }
 
}
-(void)updateOnlyAntRect {
    for (AbstractAnt *ant in self.grid.ants) {
        NSUInteger state = [[[self.grid.matrix objectAtIndex:ant.currentPos.row ] objectAtIndex: ant.currentPos.col] integerValue];
        UIBezierPath *path = [self getPathAtRow:ant.currentPos.row  andCol:ant.currentPos.col];
        UIColor *currentCol = [[self.colours objectAtIndex: state] colorWithAlphaComponent:0.5];
        [currentCol setFill];
//        [path fill];
        
        CGRect boundingRect = CGRectMake(path.bounds.origin.x, path.bounds.origin.y, path.bounds.size.width, path.bounds.size.height);
        [self setNeedsDisplayInRect:boundingRect];
    }
    
}

-(UIBezierPath*)getPathAtRow:(NSUInteger)rowNum andCol:(NSUInteger)colNum {
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat startX = (CGFloat)colNum * self.shapeWidth;
    
    CGFloat startY = (CGFloat)rowNum * self.sideHeight * 1.5;
    if (rowNum % 2 == 1) {
        startX += self.shapeWidth / 2.0;
    }
    
    [path moveToPoint: CGPointMake(startX, startY)];
    [path addLineToPoint:CGPointMake(startX + (self.shapeWidth / 2.0), startY - (self.sideHeight / 2))];
    [path addLineToPoint:CGPointMake(startX + self.shapeWidth, startY)];
    [path addLineToPoint:CGPointMake(startX + self.shapeWidth, startY + self.sideHeight)];
    [path addLineToPoint:CGPointMake(startX + (self.shapeWidth / 2.0), startY + (self.sideHeight * 1.5))];
    [path addLineToPoint:CGPointMake(startX, startY + self.sideHeight)];
    [path closePath];
    
    return path;
}




@end
