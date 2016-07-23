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
#import "SelectedRuleViewController.h"

@interface RuleDisplayVC ()

@end

@implementation RuleDisplayVC
BOOL isLandscape;
NSInteger numRules;
NSMutableArray *ruleDisplayViews;
RuleDisplayView *selectedRuleDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];
//    numRules = [Settings sharedInstance].statesListInGrid.count;
//    selectedRuleDisplay = nil;
//    [self createRuleDisplayViews];
    
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
//            [self selectRule:rsv];
            RuleDisplayView *newDisplay = [[RuleDisplayView alloc] initWithType:[Settings sharedInstance].antType  ruleValue:rsv.ruleValue ruleNumber:rsv.ruleNumber color:rsv.stateColor];
            
            for (RuleDisplayView *unusedView in ruleDisplayViews) {
                    [unusedView removeFromSuperview];

            }
            [self selectRule:newDisplay];
        }
    }
    
   
}

- (void)selectRule:(RuleDisplayView*)selectedRule {
    selectedRuleDisplay = selectedRule;
    if (isLandscape) {
        
    } else {
//        CGFloat bigWidth = self.view.frame.size.width * 0.8;
//        CGFloat sideMargin = (self.view.frame.size. width - bigWidth) / 2.0;
//        CGRect rect = CGRectMake(sideMargin, (self.view.frame.size.height - bigWidth) / 2.0, bigWidth, bigWidth * 1.2);
//        selectedRule.editable = YES;
//        selectedRule.frame = rect;
//        [self.view addSubview:selectedRule];
//        
        
        [self performSegueWithIdentifier:@"toSelectedRuleVC" sender:self];
        
        
        // TODO: animate!!
     
      
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"toSelectedRuleVC"]) {
        SelectedRuleViewController * srvc = segue.destinationViewController;
        [srvc getRuleDetails:[Settings sharedInstance].antType ruleValue:selectedRuleDisplay.ruleValue ruleNumber:selectedRuleDisplay.ruleNumber color:selectedRuleDisplay.stateColor];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    isLandscape = self.view.frame.size.width > self.view.frame.size.height;
    numRules = [Settings sharedInstance].statesListInGrid.count;
    selectedRuleDisplay = nil;
    [self createRuleDisplayViews];
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
            xOffset += spaceWidth / 1.2;
            CGRect rect = CGRectMake(xOffset, yOffset, spaceWidth * 2.0, spaceWidth * 2 * 1.2);
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
            yOffset += spaceHeight / 1.2;
            CGRect rect = CGRectMake(xOffset, yOffset, spaceHeight * 2.0, spaceHeight * 2.0 * 1.2);
            rdv.frame = rect;
            [self.view addSubview:rdv];
            yOffset += (spaceHeight * 2.0 * 1.1);

        }
        
    }
   
}
@end
