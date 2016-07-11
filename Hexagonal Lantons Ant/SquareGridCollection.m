//
//  SquareGridCollection.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "SquareGridCollection.h"

@implementation SquareGridCollection

-(void)setUpInitialViews {
    self.gridOfViews = [[NSMutableArray alloc] init];
    NSInteger rows = self.grid.numRows;
    NSInteger cols = self.grid.numCols;
    for (int row = 0; row < rows; row++) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < cols; col++) {
            CGRect rect = CGRectMake((CGFloat)col * self.boxWidth, (CGFloat)row * self.boxWidth, self.boxWidth, self.boxWidth);
            UIView *cell = [[UIView alloc] initWithFrame:rect];
            cell.backgroundColor = [UIColor whiteColor];
            [self.parentView addSubview:cell];
            [currentRow addObject:cell];
        }
        [self.gridOfViews addObject:currentRow];
    }
}

-(void)updateViews {
    [self.grid update];
    for (AbstractAnt *ant in self.grid.ants) {

        UIView *changedTile = [[self.gridOfViews objectAtIndex: ant.currentPos.row ] objectAtIndex:ant.currentPos.col];
        NSInteger newState = [[[self.grid.matrix objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col] integerValue];
        //         NSLog([NSString stringWithFormat:@"%i, %i, %li", cell.row, cell.col, newState]);
        changedTile.backgroundColor = [self.colors objectAtIndex:newState];
    }
    
}

@end
