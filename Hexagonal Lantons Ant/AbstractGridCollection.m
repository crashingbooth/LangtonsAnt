//
//  AbstractGridCollection.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractGridCollection.h"


@implementation AbstractGridCollection
NSMutableArray *gridOfViews;
UIView *parentView;
CGFloat boxSize;


-(id)initWithParentView:(UIView*)parentView grid:(Grid*)myGrid boxSize:(CGFloat)boxSizeFromVC {
    self = [super init];
    if (self) {
        self.parentView = parentView;
        self.grid = myGrid;
        self.boxSize = boxSizeFromVC;
        self.colors = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
        
        [self setUpInitialViews];
    }
    return self;
}


@end
