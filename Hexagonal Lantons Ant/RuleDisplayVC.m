//
//  RuleDisplayVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/21/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayVC.h"
#import "Settings.h"
#import "Constants.h"
#import "RuleDisplayView.h"

@interface RuleDisplayVC ()

@end

@implementation RuleDisplayVC
BOOL isLandscape;
NSInteger numRules;
NSMutableArray *ruleDisplayViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    numRules = [Settings sharedInstance].statesListInGrid.count;
    [self createRuleDisplayViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)tapped:(UITapGestureRecognizer*)gesture {
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    NSLog([NSString stringWithFormat:@"%f, %f", loc.x, loc.y]);
    
    
    for (RuleDisplayView *rsv in ruleDisplayViews) {
        if (CGRectContainsPoint(rsv.frame, loc)) {
            rsv.editable = YES;
            [rsv setUserInteractionEnabled:YES];
            [self selectRule:rsv];
            
            for (RuleDisplayView *unusedView in ruleDisplayViews) {
                if (unusedView != rsv) {
                    [unusedView removeFromSuperview];
                }
            }
        }
    }
    
   
}

- (void)selectRule:(RuleDisplayView*)selectedRule {
    if (isLandscape) {
        
    } else {
        CGFloat bigWidth = self.view.frame.size.width * 0.8;
        CGFloat sideMargin = (self.view.frame.size. width - bigWidth) / 2.0;
        CGRect rect = CGRectMake(sideMargin, (self.view.frame.size.height - bigWidth) / 2.0, bigWidth, bigWidth);
        [UIView animateWithDuration:0.2
                         animations:^{ selectedRule.frame = rect;}
                         completion:^(BOOL finished) {[selectedRule setNeedsDisplay];}
         ];
        
       
        [selectedRule setNeedsDisplay];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    isLandscape = self.view.frame.size.width > self.view.frame.size.height;
    [self positionRuleViews];
}

- (void)createRuleDisplayViews {
    AntType type = [Settings sharedInstance].antType;
    ruleDisplayViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < numRules; i++) {

        NSInteger num = [[Settings sharedInstance].statesListInGrid[i] integerValue];
        RuleDisplayView *rdv = [[RuleDisplayView alloc] initWithType:type ruleValue: num ruleNumber:i color:[[Settings sharedInstance].colorList[i] colorWithAlphaComponent:0.3]];
        rdv.editable = NO;
        [rdv setUserInteractionEnabled:NO];
        [ruleDisplayViews addObject: rdv];
    }
}

- (void)positionRuleViews {
    // spaces will be 1/2 size of rules (rule = 2 spaces)
    // # of spaces will be # of rules + 1
    NSInteger spaces = numRules * 3 + 1;
    if (isLandscape) {
    
        CGFloat spaceWidth = self.view.frame.size.width / (CGFloat) spaces;
        CGFloat yOffset = self.view.frame.size.height / 2 - spaceWidth;
        CGFloat xOffset = 0.0;
        for (RuleDisplayView * rdv in ruleDisplayViews) {
            xOffset += spaceWidth;
            CGRect rect = CGRectMake(xOffset, yOffset, spaceWidth * 2.0, spaceWidth * 2);
            rdv.frame = rect;
            [self.view addSubview:rdv];
            xOffset += (spaceWidth * 2);

        }
        
    } else {
        CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
        CGFloat spaceHeight = (self.view.frame.size.height - navBarHeight) / (CGFloat) spaces;
        CGFloat xOffset = spaceHeight;
        CGFloat yOffset = navBarHeight;
        
        for (RuleDisplayView * rdv in ruleDisplayViews) {
            yOffset += spaceHeight;
            CGRect rect = CGRectMake(xOffset, yOffset, spaceHeight * 2.0, spaceHeight * 2.0);
            rdv.frame = rect;
            [self.view addSubview:rdv];
            yOffset += (spaceHeight * 2.0);

        }
        
    }
   
}
@end
