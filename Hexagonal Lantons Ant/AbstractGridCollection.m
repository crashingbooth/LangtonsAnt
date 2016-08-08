//
//  AbstractGridCollection.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractGridCollection.h"
#import "UIViewWithPath.h"


@implementation AbstractGridCollection
NSMutableArray *gridOfViews;
NSArray *colorListForGrid;
UIView *parentView;
CGFloat boxWidth;


-(id)initWithParentView:(UIView*)parentView grid:(Grid*)myGrid boxWidth:(CGFloat)boxWidthFromVC drawAsCircle:(BOOL)drawAsCircle colorList:(NSArray*) colorList {
    self = [super init];
    if (self) {
        self.parentView = parentView;
        self.grid = myGrid;
        self.boxWidth = boxWidthFromVC;
        self.drawAsCircle = drawAsCircle;
        self.colorListForGrid = colorList;
        
        [self setUpInitialViews];
    }
    return self;
}

- (void)updateOrCreateTile:(GridPoint*) gridPoint {
    UIViewWithPath *changeTile = [[self.gridOfViews objectAtIndex: gridPoint.row ] objectAtIndex:gridPoint.col];
    NSInteger newState = [[[self.grid.matrix objectAtIndex:gridPoint.row] objectAtIndex:gridPoint.col] integerValue];
    UIColor *stateColor = self.colorListForGrid[newState % 12];
    if ([changeTile isEqual:[NSNull null]] ) {
        CGRect rect = [self getRectOfGridShape:gridPoint];
        changeTile = [self createTile:rect color:stateColor];
        [self.gridOfViews[gridPoint.row] replaceObjectAtIndex:gridPoint.col withObject:changeTile];
        
    } else {
        changeTile.color = stateColor;
    }
    [changeTile setNeedsDisplay];
}

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



- (void)removeAllViews {
    for (NSArray* row in self.gridOfViews) {
        for (UIView *cell in row) {
            if (![cell isEqual:[NSNull null]]) {
                [cell removeFromSuperview];
            }
        }
    }
}

- (void)cleanGrid {
    for (NSArray* row in self.gridOfViews) {
        for (UIViewWithPath *cell in row) {
            if (![cell isEqual:[NSNull null]]) {
                cell.color = [Settings sharedInstance].colorList[0];
            }
        }
    }
}

-(void)updateViews {
    [self.grid update];
    for (AbstractAnt *ant in self.grid.ants) {
        GridPoint *antLoc = ant.currentPos;
        [self updateOrCreateTile:antLoc];
    }
}


@end
