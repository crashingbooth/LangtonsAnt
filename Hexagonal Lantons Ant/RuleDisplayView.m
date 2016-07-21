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
NSUInteger numSectors;
UIImageView *controlArrow;
UIImageView *guideArrow;
UIView *touchZone;
CGFloat touchZoneRotation;
NSInteger ruleValue = 0;
BOOL rotating = NO;
CGFloat PI;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        PI = (CGFloat)M_PI;
        controlArrow = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
        controlArrow.image = [UIImage imageNamed:@"up-arrow.png"];

        guideArrow = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
        guideArrow.image = [UIImage imageNamed:@"purple_arrow.png"];
//        guideArrow.alpha = 0.7;
        self.type = FOUR_WAY;
        [self setUpWithAntType:EIGHT_WAY];
        
        [self addSubview:guideArrow];
        [self addSubview:controlArrow];
        touchZone = [[UIView alloc] initWithFrame:CGRectZero];
        touchZone.backgroundColor = [UIColor redColor];
        touchZoneRotation = 0.0;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
        [self addGestureRecognizer:longPress];
        longPress.minimumPressDuration = 0.01;
//        [self addSubview:touchZone];
        
    }
    return self;
}

- (void)setUpWithAntType:(AntType)type {
    self.type = type;
    switch (self.type) {
        case FOUR_WAY:
            numSectors = 4;
            break;
        case SIX_WAY:
            numSectors = 6;
            break;
        case EIGHT_WAY:
            numSectors = 8;
            break;
        default:
            break;
    }
    
}

- (void)longPressRecognized:(UILongPressGestureRecognizer*)gesture {
    CGPoint loc = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if ([touchZone pointInside:loc withEvent:nil]) {
            rotating = YES;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {

        CGFloat angle = [self getAngleFromPoint:loc];
//        NSInteger sector = [self getSectorFromAngle:angle];
//        NSLog([NSString stringWithFormat:   @"rotating %.2f rule %li", angle, (long)[self getRuleValueFromSector:sector]]);
        controlArrow.transform = CGAffineTransformMakeRotation(-1 * (angle - (PI / 2.0)));
    
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        rotating = NO;
        CGFloat angle = [self getAngleFromPoint:loc];
        NSInteger sector = [self getSectorFromAngle:angle];
        CGFloat sectorSize = (PI * 2.0) / (CGFloat)numSectors;
        CGFloat finalAngle = ((CGFloat)sector * sectorSize);
//        NSLog([NSString stringWithFormat:   @"rotating %.2f rule %li", angle, (long)[self getRuleValueFromSector:sector]]);
        controlArrow.transform = CGAffineTransformMakeRotation(-1 * (finalAngle));
        ruleValue = [self getRuleValueFromSector:sector];
        
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
    float max = (float)numSectors;
        for (float i = 0.0; i < max; i += 1.0 ) {
        [points addObject: [NSValue valueWithCGPoint:[self makePointFromRotation:i / max distanceFromEdge:distanceFromEdge]]];
    }

    return points;
}

- (CGPoint)makePointFromRotation:(float)rotation distanceFromEdge:(CGFloat)distanceFromEdge {
    CGFloat radius = (self.frame.size.width / 2.0) - distanceFromEdge;
    CGFloat rotationInRadians = (PI * 2.0 * rotation) + (PI / 2.0);
    CGFloat x = cosf(rotationInRadians) * radius + (self.frame.size.width / 2.0);
    CGFloat y = (self.frame.size.height / 2.0) - sinf(rotationInRadians)* radius;
    return CGPointMake(x, y);
}

- (CGFloat)getAngleFromPoint:(CGPoint)point {
    CGFloat y = (self.frame.size.height / 2.0) - point.y;
    CGFloat x = point.x - (self.frame.size.width / 2.0);
    CGFloat angle = atan2f(y, x);
    if (angle < 0.0) {
        angle += (PI * 2.0);
    }
    return angle;
}

- (NSInteger)getSectorFromAngle:(CGFloat)angle {
    CGFloat modAngle = angle - (PI / 2.0);
    
    CGFloat sectorAngle = (PI * 2.0) / (CGFloat)numSectors;
    if (modAngle < -1 * (sectorAngle / 2.0)) {
        modAngle += (PI * 2.0);
    }
   
    for (int sector = 0; sector < numSectors; sector++) {
        CGFloat minAngle = (sectorAngle * (CGFloat)sector) - (sectorAngle / 2.0);
        CGFloat maxAngle = (sectorAngle * (CGFloat)(sector + 1)) - (sectorAngle / 2.0);
        
        if (modAngle >= minAngle && modAngle < maxAngle) {
            return sector;
        }
        
    }
    NSLog(@"failed");
    return -1;
}

- (NSInteger)getRuleValueFromSector:(NSInteger)sector {
    NSInteger rule = numSectors - sector;
    if (rule > numSectors / 2) {
        rule -= numSectors;
    }
    return rule;
}


@end
