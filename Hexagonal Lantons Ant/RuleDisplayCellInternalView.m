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
NSInteger numberOfRulesToDisplay;
RuleDisplayView *selectedRDV;
NSMutableArray *menuRuleDisplayViews;
- (void)setUp {
    self.rdcWidth = self.frame.size.width;
    [self createRuleDisplayViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
}

- (void) createRuleDisplayViews {
    CGFloat h = self.frame.size.height;
    // clean up old array if nec
    numberOfRulesToDisplay = [Settings sharedInstance].statesListInGrid.count;
    menuRuleDisplayViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < numberOfRulesToDisplay; i++) {
        NSInteger num = [[Settings sharedInstance].statesListInGrid[i] integerValue];
        RuleDisplayView *rdv = [[RuleDisplayView alloc] initWithType:[Settings sharedInstance].antType ruleValue: num ruleNumber:i color:[[Settings sharedInstance].colorList[i] colorWithAlphaComponent:0.3]];
        rdv.editable = NO;
        [rdv setUserInteractionEnabled:NO];
        [menuRuleDisplayViews addObject: rdv];
    }
    [self positionRuleViews];
}



- (void)positionRuleViews {
    iconWidth = (self.rdcWidth -(minSpace * 9.0)) / 8.0;
    if (iconWidth * 1.2 > selfHeight) {
        iconWidth = selfHeight / 1.2;
    }
    space = (self.rdcWidth - (numberOfRulesToDisplay * iconWidth)) / (numberOfRulesToDisplay + 1);
    CGFloat yOffset = (selfHeight - (iconWidth * 1.2)) / 2.0;
    CGFloat xOffset = 0.0;
        for (RuleDisplayView * rdv in menuRuleDisplayViews) {
            xOffset += space;
            CGRect rect = CGRectMake(xOffset, yOffset, iconWidth, iconWidth * 1.2);
            rdv.frame = rect;
            [self addSubview:rdv];
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
    NSLog([NSString stringWithFormat:@"%f, %f", loc.x, loc.y]);
    
    
    for (RuleDisplayView *rsv in menuRuleDisplayViews) {
        if (CGRectContainsPoint(rsv.frame, loc)) {
//            RuleDisplayView *newDisplay = [[RuleDisplayView alloc] initWithType:[Settings sharedInstance].antType  ruleValue:rsv.ruleValue ruleNumber:rsv.ruleNumber color:rsv.stateColor];
            
            [self cleanUp];
            selectedRDV = rsv;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger: rsv.ruleNumber] forKey:@"ruleNumber"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentEditableVC" object:nil userInfo:userInfo];
            

            
        }
    }
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
