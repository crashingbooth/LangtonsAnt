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
UILabel *stateNumLabel;
UILabel *stateValLabel;


UIColor *stateColor;
NSInteger ruleValue;
BOOL editable = NO;
CGFloat PI;
CGFloat sectorSize;
Settings *ruleDisplaySettings;
NSArray *stateNames; // 2d array





- (id)initWithType:(AntType) type ruleValue:(NSInteger)ruleValue ruleNumber:(NSInteger) ruleNumber color:(UIColor*) stateColor {
    self = [super init];
    if (self) {
        [self basicSetup];
        [self setUpWithAntType:type];
        self.stateColor = stateColor;
       
        self.ruleValue = ruleValue;
        self.ruleNumber = ruleNumber;
        
        [self createLabelText];
        
            }

    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self basicSetup];
    }
    return self;
}

- (void)basicSetup {
    ruleDisplaySettings = [Settings sharedInstance];
    PI = (CGFloat)M_PI;
    
    self.guideArrow = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
    self.guideArrow.image = [UIImage imageNamed:@"purple_arrow.png"];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.guideArrow];
    [self addSubview:self.controlArrow];
    self.stateNumLabel = [[UILabel alloc] init];
    [self addSubview:self.stateNumLabel];
    self.stateNumLabel.adjustsFontSizeToFitWidth = YES;
    self.stateNumLabel.font = [self.stateNumLabel.font fontWithSize:8];
    self.stateNumLabel.textAlignment = NSTextAlignmentCenter;
    self.stateNumLabel.textColor = [UIColor blueColor];
    self.stateNumLabel.minimumScaleFactor = 20;
    self.stateValLabel = [[UILabel alloc] init];
    [self addSubview:self.stateValLabel];

    self.stateValLabel.adjustsFontSizeToFitWidth = YES;
    self.stateValLabel.minimumScaleFactor = 20;
    self.stateNumLabel.font = [self.stateValLabel.font fontWithSize:8];
    self.stateValLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self addGestureRecognizer:longPress];
    longPress.minimumPressDuration = 0.01;
}

- (void)completeSetUp:(AntType) type ruleValue:(NSInteger)ruleValue ruleNumber:(NSInteger) ruleNumber color:(UIColor*) stateColor {
    // when called from storyboard, use 2 step init
    
    [self setUpWithAntType:type];
    self.stateColor = stateColor;
    self.ruleValue = ruleValue;
    self.ruleNumber = ruleNumber;
    [self createLabelText];
}

- (void)createLabelText{
    if (editable) {
        self.stateNumLabel.text = [NSString stringWithFormat:@"State: %li", (long)self.ruleNumber];
    } else {
        self.stateNumLabel.text = [NSString stringWithFormat:@"%li", (long)self.ruleNumber];
    }
    self.stateValLabel.text = [[Settings sharedInstance] getStateName:self.ruleValue forAntType:self.type];
    
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
    sectorSize = (PI * 2) / (CGFloat)numSectors;
}

- (void)longPressRecognized:(UILongPressGestureRecognizer*)gesture {
    CGPoint loc = [gesture locationInView:self];
    if (self.editable) {
        if (gesture.state == UIGestureRecognizerStateChanged) {
            
            CGFloat angle = [self getAngleFromPoint:loc];
            //        NSInteger sector = [self getSectorFromAngle:angle];
            //        NSLog([NSString stringWithFormat:   @"rotating %.2f rule %li", angle, (long)[self getRuleValueFromSector:sector]]);
            self.controlArrow.transform = CGAffineTransformMakeRotation(-1 * (angle - (PI / 2.0)));
            
            
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            
            CGFloat angle = [self getAngleFromPoint:loc];
            NSInteger sector = [self getSectorFromAngle:angle];
            NSInteger newRuleValue = [self getRuleValueFromSector:sector];
            if (newRuleValue != self.ruleValue) {
                CGFloat finalAngle = ((CGFloat)sector * sectorSize);
                self.controlArrow.transform = CGAffineTransformMakeRotation(-1 * (finalAngle));
                self.ruleValue = newRuleValue;
                [self createLabelText];
                [self changeSettings];
            }
        }
    }
}

- (void)changeSettings {
    NSMutableArray *stateList = [[Settings sharedInstance].statesListInGrid mutableCopy];
    [stateList replaceObjectAtIndex:self.ruleNumber withObject:[NSNumber numberWithInteger:self.ruleValue]];
    [Settings sharedInstance].statesListInGrid = stateList;
    [[Settings sharedInstance] recreateGrid];
    [Settings sharedInstance].name = @"custom";
}


- (void)drawRect:(CGRect)rect {
    CGFloat sideLength = self.frame.size.width;
    CGFloat heightOffset = (self.frame.size.height - sideLength) / 2.0;
    CGFloat circleWidth = sideLength * 0.05;
    CGRect circleRect = CGRectMake(circleWidth / 2.0, heightOffset + (circleWidth / 2.0), sideLength -  circleWidth,  sideLength - circleWidth);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [circlePath setLineWidth: circleWidth];
    [self.stateColor setFill];
    [circlePath fill];
    [circlePath stroke];
    CGRect guideBounds = CGRectMake(circleWidth * 5, heightOffset + (circleWidth * 5), sideLength - (circleWidth * 10), sideLength - (circleWidth * 10));
   
    self.guideArrow.frame = guideBounds;
    [self recreateArrow];

    for (NSNumber *pointNum in [self markerPoints:(circleWidth *2)]) {
        CGPoint point = [pointNum CGPointValue];
        UIBezierPath *markerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - (circleWidth / 2.0), point.y - (circleWidth / 2.0), circleWidth, circleWidth)];
        [[UIColor purpleColor] setFill];
        [markerPath fill];
        
    }
    
    CGRect topLabelRect = CGRectMake(0, 0, sideLength / 2.0, sideLength * 0.2);
    CGRect bottomLabelRect = CGRectMake(0, 0, sideLength / 2.0, sideLength * 0.2);
    self.stateNumLabel.frame = topLabelRect;
    self.stateValLabel.frame = bottomLabelRect;
    if (self.editable) {
        [self createLabelText];
        self.stateNumLabel.font = [self.stateNumLabel.font fontWithSize:15];
        self.stateValLabel.font = [self.stateValLabel.font fontWithSize:15];
    } else {
        self.stateNumLabel.font = [self.stateNumLabel.font fontWithSize:8];
        self.stateValLabel.font = [self.stateValLabel.font fontWithSize:8];
    }
    [self.stateNumLabel setCenter:CGPointMake(sideLength / 2.0, heightOffset / 2.0)];
    [self.stateValLabel setCenter:CGPointMake(sideLength / 2.0, heightOffset + sideLength + heightOffset / 2.0)];
}



- (CGRect)controlArrowFrame:(CGRect)superViewFrame{
    CGFloat sideLength = superViewFrame.size.width;
    CGFloat heightOffset = (superViewFrame.size.height - sideLength) / 2.0;
    CGFloat circleWidth = sideLength * 0.05;
    CGRect arrowBounds = CGRectMake(circleWidth * 2, heightOffset + (circleWidth * 2), sideLength - (circleWidth * 4), sideLength - (circleWidth * 4));
    
    return arrowBounds;
}

- (void)recreateArrow {
    if ([self.controlArrow isDescendantOfView:self]) {
        [self.controlArrow removeFromSuperview];
    }
    
    self.controlArrow = [[UIImageView alloc] initWithFrame:[self controlArrowFrame:self.bounds]];
    self.controlArrow.image = [UIImage imageNamed:@"up-arrow.png"];
    
    self.controlArrow.transform =  CGAffineTransformIdentity;
    self.controlArrow.transform = CGAffineTransformMakeRotation([self getAngleFromRule:self.ruleValue]);
    [self addSubview:self.controlArrow];
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
    
    
    if (modAngle < -1 * (sectorSize / 2.0)) {
        modAngle += (PI * 2.0);
    }
   
    for (int sector = 0; sector < numSectors; sector++) {
        CGFloat minAngle = (sectorSize * (CGFloat)sector) - (sectorSize / 2.0);
        CGFloat maxAngle = (sectorSize * (CGFloat)(sector + 1)) - (sectorSize / 2.0);
        
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

- (NSInteger)getSectorFromRule:(NSInteger)rule {
    if (rule < 0) {
        rule += numSectors;
    }
    return numSectors - rule;
}

- (CGFloat)getAngleFromRule:(NSInteger)rule {
    return -1 * (sectorSize * (CGFloat)[self getSectorFromRule:rule]);
}


@end
