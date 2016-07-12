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
            CGFloat startX = (CGFloat)col * self.boxWidth;
            if (row % 2 == 1) {
                startX += self.boxWidth / 2.0;
            }
            
            CGRect rect = CGRectMake(startX, (CGFloat)row * [self sideHeight] * 1.5, self.boxWidth, [self sideHeight] * 2);
            UIViewWithPath *cell = [[UIViewWithPath alloc] initWithFrame:rect];
            cell.backgroundColor = [UIColor clearColor];
            
            if (self.drawAsCircle == YES) {
                cell.pathShape = CIRCLE;
            } else {
                cell.pathShape = HEXAGON;
            }

            cell.path = [cell getPath];
            cell.color = self.colors[0];
            [cell setNeedsDisplay];
            [self.parentView addSubview:cell];
            [currentRow addObject:cell];
        }
        [self.gridOfViews addObject:currentRow];
    }
}
-(CGFloat)sideHeight {
    return self.boxWidth * 0.577350269;
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
