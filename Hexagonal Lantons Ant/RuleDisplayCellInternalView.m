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
CGFloat selfHeight = 71.5; // stipulated in MainMenuTVC
CGFloat heightWidthRatio = 1.4;
CGFloat MAX_RULES = 8.0;
CGFloat alphaOfSubview = 0.8;
NSInteger numberOfRulesToDisplay;
RuleDisplayView *selectedRDV;
NSMutableArray *menuRuleDisplayViews;
- (void)setUp {
    self.rdcWidth = self.frame.size.width;
    [self createRuleDisplayViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@ selector(receivedNotification:) name:@"stateDeleted" object:nil ];
}

- (void) createRuleDisplayViews {
//    CGFloat h = self.frame.size.height;
    // clean up old array if nec
    numberOfRulesToDisplay = [Settings sharedInstance].statesListInGrid.count;
    menuRuleDisplayViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < numberOfRulesToDisplay; i++) {
        NSInteger num = [[Settings sharedInstance].statesListInGrid[i] integerValue];
        RuleDisplayView *rdv = [[RuleDisplayView alloc] initWithType:[Settings sharedInstance].antType ruleValue: num ruleNumber:i color:[[Settings sharedInstance].colorList[i] colorWithAlphaComponent:alphaOfSubview]];
        rdv.editable = NO;
        [rdv setUserInteractionEnabled:NO];
        [menuRuleDisplayViews addObject: rdv];
    }
    [self positionRuleViews];
}

- (void)receivedNotification:(NSNotification*) notification {
    if ([notification.name isEqualToString:@"stateDeleted"]) {
        NSLog(@"delete notification");
        MAX_RULES = 8.0;
        [self cleanUp];
        [self createRuleDisplayViews];
    }
}



- (void)positionRuleViews {
    
    // assume there will be less than 8 rule, after 8 adjust sizes
    if (numberOfRulesToDisplay > MAX_RULES) {
        MAX_RULES = numberOfRulesToDisplay;
    }
    
    iconWidth = (self.rdcWidth -(minSpace * (MAX_RULES + 1))) / MAX_RULES;
    if (iconWidth * heightWidthRatio  > selfHeight) {
        iconWidth = selfHeight / heightWidthRatio;
    }
    space = (self.rdcWidth - (numberOfRulesToDisplay * iconWidth)) / (numberOfRulesToDisplay + 1);
    CGFloat yOffset = (selfHeight - (iconWidth * heightWidthRatio )) / 2.0;
    CGFloat xOffset = 0.0;
        for (RuleDisplayView * rdv in menuRuleDisplayViews) {
            xOffset += space;
            CGRect rect = CGRectMake(xOffset, yOffset, iconWidth, iconWidth * heightWidthRatio );
            rdv.frame = rect;
            if (![rdv isDescendantOfView:self]) {
                  [self addSubview:rdv];
            } else {
                [rdv removeFromSuperview];
                [self addSubview:rdv];
                [rdv setNeedsDisplay];
            }
                
          
            xOffset += iconWidth;
            
        }
}

- (void)cleanUp {
    for (RuleDisplayView *rdv in menuRuleDisplayViews) {
        [rdv removeFromSuperview];
        
    }
}

- (void)tapped:(UITapGestureRecognizer*)gesture {
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    NSLog(@"%f, %f", loc.x, loc.y);
    
    
    for (RuleDisplayView *rsv in menuRuleDisplayViews) {
        if (CGRectContainsPoint(rsv.frame, loc)) {
            [self cleanUp];
            selectedRDV = rsv;
            // send to mainMenuTVC
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger: rsv.ruleNumber] forKey:@"ruleNumber"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentEditableVC" object:nil userInfo:userInfo];
            

            
        }
    }
}

- (void)addViewWithAnimation {
    [[Settings sharedInstance] addState];
    numberOfRulesToDisplay += 1;
    NSInteger num = numberOfRulesToDisplay - 1;
    NSInteger val = [[Settings sharedInstance].statesListInGrid[numberOfRulesToDisplay - 1] integerValue];
    UIColor *col = [[Settings sharedInstance].colorList[num] colorWithAlphaComponent:alphaOfSubview];
    AntType newType = [Settings sharedInstance].antType;
    
    RuleDisplayView *newView = [[RuleDisplayView alloc] initWithType:newType ruleValue:val ruleNumber:num color:col];
    newView.editable = NO;
    [newView setUserInteractionEnabled:NO];
    [menuRuleDisplayViews addObject:newView];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self positionRuleViews];
        for (RuleDisplayView *rdv in menuRuleDisplayViews) {
            
            [rdv setNeedsDisplay];
        }
    } ];
    
    
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
