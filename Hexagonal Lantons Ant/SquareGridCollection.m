//
//  SquareGridCollection.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "SquareGridCollection.h"
#import "UIViewWithPath.h"

@implementation SquareGridCollection

-(void)setUpInitialViews {
    NSInteger rows = self.grid.numRows;
    NSInteger cols = self.grid.numCols;
    self.gridOfViews = [NSMutableArray arrayWithCapacity:rows];
    for (int row = 0; row < rows; row++) {
        NSMutableArray *currentRow = [NSMutableArray arrayWithCapacity:cols];
        for (int col = 0; col < cols; col++) {
            [currentRow addObject:[NSNull null]];
        }
        [self.gridOfViews addObject:currentRow];
    }
}

- (void)updateOrCreateTile:(GridPoint*) gridPoint {
    UIViewWithPath *changeTile = [[self.gridOfViews objectAtIndex: gridPoint.row ] objectAtIndex:gridPoint.col];
    NSInteger newState = [[[self.grid.matrix objectAtIndex:gridPoint.row] objectAtIndex:gridPoint.col] integerValue];
    UIColor *stateColor = [Settings sharedInstance].colorList[newState];
    if ([changeTile isEqual:[NSNull null]] ) {
        CGRect rect = CGRectMake((CGFloat)gridPoint.col * self.boxWidth, (CGFloat)gridPoint.row * self.boxWidth, self.boxWidth, self.boxWidth);
        changeTile = [self createTile:rect color:stateColor];
        [self.gridOfViews[gridPoint.row] replaceObjectAtIndex:gridPoint.col withObject:changeTile];

    } else {
            changeTile.color = stateColor;
    }
    [changeTile setNeedsDisplay];
}

- (UIViewWithPath*)createTile:(CGRect)frame color:(UIColor*)color {

    UIViewWithPath *cell = [[UIViewWithPath alloc] initWithFrame:frame];
    cell.backgroundColor = [UIColor clearColor];
    if (self.drawAsCircle == YES) {
        cell.pathShape = CIRCLE;
    } else {
        cell.pathShape = SQUARE;
    }
    cell.color = color;
    cell.path = [cell getPath];
    [self.parentView addSubview:cell];
    
    return cell;
}

-(void)updateViews {
    [self.grid update];
    for (AbstractAnt *ant in self.grid.ants) {
        GridPoint *antLoc = ant.currentPos;
        [self updateOrCreateTile:antLoc];
    }
}

@end
