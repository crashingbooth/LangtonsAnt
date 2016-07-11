//
//  UIViewWithPath.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "UIViewWithPath.h"

@implementation UIViewWithPath
UIBezierPath *path;
UIColor *color;


- (void)drawRect:(CGRect)rect {
    [color setFill];
    [path fill];
}


@end
