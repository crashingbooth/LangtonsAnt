//
//  UIViewWithPath.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewWithPath : UIView
typedef NS_ENUM(NSInteger, PathShape) {
    SQUARE = 0, CIRCLE = 1, HEXAGON = 2
};

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) PathShape pathShape;
-(UIBezierPath*)getPath;



@end
