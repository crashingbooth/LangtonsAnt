//
//  ColorSchemeInternalView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ColorSchemeInternalView.h"

@implementation ColorSchemeInternalView

- (void)setUp:(NSInteger)index {
    self.colorSchemeIndex = index;
    self.colorListForColorScheme = [[Settings sharedInstance] assignColorScheme:index];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"added Rule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"stateDeleted" object:nil ];
}




- (void)drawRect:(CGRect)rect {
    self.numStatesForColorScheme = [Settings sharedInstance].statesListInGrid.count;
    CGFloat maxNumStates = 12.0;
    CGFloat spacing = 5.0;
    CGFloat circleDiameter = (self.frame.size.width - ((maxNumStates + 1) * spacing)) / maxNumStates;
    if (circleDiameter > self.frame.size.height * 0.8) {
        circleDiameter = self.frame.size.height * 0.8;
    }
    
    CGFloat yOffset = (self.frame.size.height - circleDiameter) / 2.0;
    CGFloat actualDisplayWidth = circleDiameter * self.numStatesForColorScheme + ((self.numStatesForColorScheme + 1) * spacing);
    CGFloat xOffset = (self.frame.size.width - actualDisplayWidth) / 2.0;
    
    for (int i = 0; i < self.numStatesForColorScheme; i++) {
        xOffset += spacing;
        CGRect rect = CGRectMake(xOffset, yOffset, circleDiameter, circleDiameter);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [self.colorListForColorScheme[i % 12] setFill];
        [[UIColor blackColor] setStroke];
        [path stroke];
        [path fill];
        
        xOffset += circleDiameter;
    }
}

- (void)update:(NSNotification*) notification {
    if ([notification.name isEqualToString:@"added Rule"]) {
        [self setNeedsDisplay];
    } else  if ([notification.name isEqualToString:@"stateDeleted"]) {
        [self setNeedsDisplay];
    }
    
}


@end
