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
UIImageView *guideArrow;
UIView *touchZone;
CGFloat touchZoneRotation;
BOOL rotating = NO;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        controlArrow = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
        controlArrow.image = [UIImage imageNamed:@"up-arrow.png"];

        guideArrow = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
        guideArrow.image = [UIImage imageNamed:@"purple_arrow.png"];
//        guideArrow.alpha = 0.7;
        self.type = FOUR_WAY;
        [self addSubview:guideArrow];
        [self addSubview:controlArrow];
        touchZone = [[UIView alloc] initWithFrame:CGRectZero];
        touchZone.backgroundColor = [UIColor redColor];
        touchZoneRotation = 0.0;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
        [self addGestureRecognizer:longPress];
        longPress.minimumPressDuration = 0.05;
        [self addSubview:touchZone];
        
       
    }
    return self;
}

- (void)longPressRecognized:(UILongPressGestureRecognizer*)gesture {
    CGPoint loc = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if ([touchZone pointInside:loc withEvent:nil]) {
            rotating = YES;
            NSLog([NSString stringWithFormat:   @"started %.2f", [self getAngleFromPoint:loc]]);
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
         NSLog([NSString stringWithFormat:   @"rotating %.2f", [self getAngleFromPoint:loc]]);
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        rotating = YES;
        NSLog(@"finished");

    }
    
}


- (void)drawRect:(CGRect)rect {
    CGFloat circleWidth = self.frame.size.height * 0.05;
    CGRect circleRect = CGRectMake(circleWidth / 2.0, circleWidth / 2.0, self.frame.size.height -  circleWidth,  self.frame.size.width - circleWidth);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [circlePath setLineWidth: circleWidth];
    [circlePath stroke];
    CGRect arrowBounds = CGRectMake(circleWidth * 2, circleWidth * 2, self.frame.size.width - (circleWidth * 4), self.frame.size.height - (circleWidth * 4));
    CGRect guideBounds = CGRectMake(circleWidth * 5, circleWidth * 5, self.frame.size.width - (circleWidth * 10), self.frame.size.height - (circleWidth * 10));
    controlArrow.frame = arrowBounds;
    guideArrow.frame = guideBounds;
    

    for (NSNumber *pointNum in [self markerPoints:(circleWidth *2)]) {
        CGPoint point = [pointNum CGPointValue];
        UIBezierPath *markerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - (circleWidth / 2.0), point.y - (circleWidth / 2.0), circleWidth, circleWidth)];
        [[UIColor purpleColor] setFill];
        [markerPath fill];
        
    }
    
    CGPoint zonePoint = [self makePointFromRotation:touchZoneRotation distanceFromEdge:circleWidth * 2];
    touchZone.frame = CGRectMake(zonePoint.x - (circleWidth * 1.5), zonePoint.y - (circleWidth * 1.5), circleWidth * 3, circleWidth * 3);
    
    
    
}

- (NSMutableArray*)markerPoints:(CGFloat)distanceFromEdge {
    NSMutableArray *points = [[NSMutableArray alloc] init];
      float max;
    switch (type) {
        case FOUR_WAY:
            max = 4.0;
            break;
        case SIX_WAY:
            max = 6.0;
            break;
        case EIGHT_WAY:
            max = 8.0;
            break;
        default:
            break;
    }
    for (float i = 0.0; i < max; i += 1.0 ) {
        [points addObject: [NSValue valueWithCGPoint:[self makePointFromRotation:i / max distanceFromEdge:distanceFromEdge]]];
    }

    return points;
}

- (CGPoint) makePointFromRotation:(float)rotation distanceFromEdge:(CGFloat)distanceFromEdge {
    CGFloat PI = (float)(M_PI);
    CGFloat radius = (self.frame.size.width / 2.0) - distanceFromEdge;
    CGFloat rotationInRadians = (PI * 2.0 * rotation) + (PI / 2.0);
    CGFloat x = cosf(rotationInRadians) * radius + (self.frame.size.width / 2.0);
    CGFloat y = (self.frame.size.height / 2.0) - sinf(rotationInRadians)* radius;
    return CGPointMake(x, y);
}

- (CGFloat) getAngleFromPoint:(CGPoint)point {
    CGFloat PI = (float)(M_PI);
    CGFloat y = (self.frame.size.height / 2.0) - point.y;
    CGFloat x = point.x - (self.frame.size.width / 2.0);
    CGFloat angle = atan2f(y, x);
    if (angle < 0.0) {
        angle += (PI * 2.0);
    }
    return angle;
}


@end
