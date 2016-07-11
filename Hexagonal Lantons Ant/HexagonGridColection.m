//
//  HexagonGridColection.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "HexagonGridColection.h"
#import "UIViewWithPath.h"
#import <UIKit/UIKit.h>

@implementation HexagonGridColection


-(void)setUpInitialViews {
    self.gridOfViews = [[NSMutableArray alloc] init];
    NSInteger rows = self.grid.numRows;
    NSInteger cols = self.grid.numCols;
    for (int row = 0; row < rows; row++) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < cols; col++) {
            CGFloat startX = (CGFloat)col * self.boxSize;
            if (row % 2 == 1) {
                startX += self.boxSize / 2.0;
            }
            
            CGRect rect = CGRectMake(startX, (CGFloat)row * [self boxHeight], self.boxSize, [self boxHeight]);
            UIViewWithPath *cell = [[UIViewWithPath alloc] initWithFrame:rect];
            cell.backgroundColor = [UIColor clearColor];
            
            
            UIBezierPath *path = [self getPathAtRow:row andCol:col];
            cell.path = path;
            cell.color = self.colors[0];
            [self.parentView addSubview:cell];
            [currentRow addObject:cell];
        }
        [self.gridOfViews addObject:currentRow];
    }
}
-(CGFloat)boxHeight {
    return self.boxSize * 0.577350269;
}
-(UIBezierPath*)getPathAtRow:(NSUInteger)rowNum andCol:(NSUInteger)colNum {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat startY = [self boxHeight] / 2.0;


    [path moveToPoint: CGPointMake(0, startY)];
    [path addLineToPoint:CGPointMake(self.boxSize / 2.0, 0)];
    [path addLineToPoint:CGPointMake(self.boxSize, startY)];
    [path addLineToPoint:CGPointMake(self.boxSize, startY + [self boxHeight])];
    [path addLineToPoint:CGPointMake(self.boxSize / 2.0, [self boxHeight] * 2)];
    [path addLineToPoint:CGPointMake(0, startY + [self boxHeight])];
    [path closePath];

    return path;
}



-(void)updateViews {
    [self.grid update];
    for (AbstractAnt *ant in self.grid.ants) {
        
        UIViewWithPath *changedTile = [[self.gridOfViews objectAtIndex: ant.currentPos.row ] objectAtIndex:ant.currentPos.col];
        NSInteger newState = [[[self.grid.matrix objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col] integerValue];
        //         NSLog([NSString stringWithFormat:@"%i, %i, %li", cell.row, cell.col, newState]);
        changedTile.color = [self.colors objectAtIndex:newState];
        [changedTile setNeedsDisplay];
    }
    
}

@end
