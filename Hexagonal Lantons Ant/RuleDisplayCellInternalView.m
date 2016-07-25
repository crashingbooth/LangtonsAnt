//
//  RuleDisplayCellInternalView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/26/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayCellInternalView.h"

@implementation RuleDisplayCellInternalView
CGFloat rdcWidth;
CGFloat minSpace = 5;
CGFloat space;
CGFloat iconWidth;
- (void)setUp {
    self.rdcWidth = self.frame.size.width;
    iconWidth = (rdcWidth -(minSpace * 9.0)) / 8.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
