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
UIView *parentView;
CGFloat boxWidth;


-(id)initWithParentView:(UIView*)parentView grid:(Grid*)myGrid boxWidth:(CGFloat)boxWidthFromVC drawAsCircle:(BOOL)drawAsCircle {
    self = [super init];
    if (self) {
        self.parentView = parentView;
        self.grid = myGrid;
        self.boxWidth = boxWidthFromVC;
        self.drawAsCircle = drawAsCircle;

        NSLog(@"starting GridColl setUp");
        [self setUpInitialViews];
        NSLog(@"finishedGridColl setUp");
    }
    return self;
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
            [cell removeFromSuperview];
        }
    }
}

- (void)cleanGrid {
    for (NSArray* row in self.gridOfViews) {
        for (UIViewWithPath *cell in row) {
            cell.color = [Settings sharedInstance].colorList[0];
        }
    }
}


@end
