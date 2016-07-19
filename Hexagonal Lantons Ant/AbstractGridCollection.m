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
        self.colors = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
        
        [self setUpInitialViews];
    }
    return self;
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
            cell.color = self.colors[0];
        }
    }
}


@end
