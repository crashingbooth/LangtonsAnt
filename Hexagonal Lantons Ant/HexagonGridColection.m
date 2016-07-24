//
//  HexagonGridColection.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "HexagonGridColection.h"
#import "UIViewWithPath.h"
#import <UIKit/UIKit.h>

@implementation HexagonGridColection



-(CGFloat)sideHeight {
    return self.boxWidth * 0.577350269;

}

- (UIViewWithPath*)createTile:(CGRect)frame color:(UIColor*)color {
    
    UIViewWithPath *cell = [[UIViewWithPath alloc] initWithFrame:frame];
    cell.backgroundColor = [UIColor clearColor];
    cell.pathShape = HEXAGON;
    cell.color = color;
    cell.path = [cell getPath];
    [self.parentView addSubview:cell];
    
    return cell;
}



-(CGRect)getRectOfGridShape:(GridPoint*)gridPoint {
    
    CGFloat startX = (CGFloat)gridPoint.col * self.boxWidth;
    if (gridPoint.row % 2 == 1) { startX += self.boxWidth / 2.0; }
    CGRect rect = CGRectMake(startX, (CGFloat)gridPoint.row * [self sideHeight] * 1.5, self.boxWidth, [self sideHeight] * 2);
    return rect;
}





@end
