//
//  ColorSchemeInternalView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ColorSchemeInternalView.h"

@implementation ColorSchemeInternalView
NSArray *colorListForColorScheme;
NSInteger numStatesForColorScheme;
NSInteger colorSchemeIndex;

- (void)setUp:(NSInteger)index {
    self.colorSchemeIndex = index;
    self.colorListForColorScheme = [[Settings sharedInstance] assignColorScheme:index];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"added Rule" object:nil];
}




- (void)drawRect:(CGRect)rect {
    self.numStatesForColorScheme = [Settings sharedInstance].statesListInGrid.count;
    CGFloat maxNumStates = 12.0;
    CGFloat xPadding = 4.0;
    CGFloat circleDiameter = (self.frame.size.width - (xPadding * 2.0)) / maxNumStates;
    if (circleDiameter > self.frame.size.height * 0.9) {
        circleDiameter = self.frame.size.height * 0.9;
    }
    
    CGFloat yOffset = (self.frame.size.height - circleDiameter) / 2.0;
    CGFloat actualDisplayWidth = circleDiameter * self.numStatesForColorScheme;
    CGFloat xOffset = (self.frame.size.width - actualDisplayWidth) / 2.0 + xPadding;
    
    for (int i = 0; i < self.numStatesForColorScheme; i++) {
        CGRect rect = CGRectMake(xOffset, yOffset, circleDiameter, circleDiameter);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [self.colorListForColorScheme[i] setFill];
        [[UIColor blackColor] setStroke];
        [path stroke];
        [path fill];
        
        xOffset += circleDiameter;
    }
}

- (void)update:(NSNotification*) notification {
    if ([notification.name isEqualToString:@"added Rule"]) {
        [self setNeedsDisplay];
    }
    
}


@end
