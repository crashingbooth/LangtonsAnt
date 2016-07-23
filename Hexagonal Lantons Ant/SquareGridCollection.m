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




- (CGRect)getRectOfGridShape:(GridPoint*) gridPoint{
    CGRect rect = CGRectMake((CGFloat)gridPoint.col * self.boxWidth, (CGFloat)gridPoint.row * self.boxWidth, self.boxWidth, self.boxWidth);
    return rect;
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


@end
