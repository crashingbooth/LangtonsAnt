//
//  RuleDisplayView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/20/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayView.h"

@implementation RuleDisplayView
AntType type;
UIImageView *controlArrow;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        controlArrow = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
        controlArrow.image = [UIImage imageNamed:@"up-arrow.png"];
        [self addSubview:controlArrow];
       
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGFloat circleWidth = self.frame.size.height * 0.05;
    CGRect circleRect = CGRectMake(circleWidth / 2.0, circleWidth / 2.0, self.frame.size.height -  circleWidth,  self.frame.size.width - circleWidth);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [circlePath setLineWidth: circleWidth];
    [circlePath stroke];
    CGRect arrowBounds = CGRectMake(circleWidth * 2, circleWidth * 2, self.frame.size.width - (circleWidth * 4), self.frame.size.height - (circleWidth * 4
                                                                                                                                           ));
    controlArrow.frame = arrowBounds;
    
}


@end
