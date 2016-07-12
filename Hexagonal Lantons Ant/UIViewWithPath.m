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
PathShape pathShape;



- (void)drawRect:(CGRect)rect {
    [self.color setFill];
    [self.color setStroke];
    [self.path fill];
    [self.path stroke];
}

-(UIBezierPath*)getPath {
    switch (self.pathShape) {
        case SQUARE:
            return [self getSquarePath];
            break;
        case CIRCLE:
            return [self getCirclePath];
            break;
        case HEXAGON:
            return [self getHexagonPath];
            break;
            
        default:
            NSLog(@"pathShape not set properly");
            break;
    }
    return [self getCirclePath];
}

-(UIBezierPath*)getSquarePath {
    return [UIBezierPath bezierPathWithRect:self.bounds];
}

-(UIBezierPath*)getCirclePath {
    CGFloat margin = 0.5;
    CGRect smallRect = CGRectMake(margin, margin, self.bounds.size.width - (margin * 2), self.bounds.size.height - (margin * 2));
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:smallRect];
    return path;
}

-(UIBezierPath*)getHexagonPath {
    CGFloat sideHeight = self.bounds.size.height / 2;
    CGFloat boxWidth = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat startY = sideHeight / 2.0;
    
    
    [path moveToPoint: CGPointMake(0, startY)];
    [path addLineToPoint:CGPointMake(boxWidth / 2.0, 0)];
    [path addLineToPoint:CGPointMake(boxWidth, startY)];
    [path addLineToPoint:CGPointMake(boxWidth, startY + sideHeight)];
    [path addLineToPoint:CGPointMake(boxWidth / 2.0, sideHeight * 2)];
    [path addLineToPoint:CGPointMake(0, startY + sideHeight)];
    [path closePath];
    
    return path;
}

// idea: create path in this class by passing geometry

@end
