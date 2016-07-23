//
//  SelectedRuleViewController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/23/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "SelectedRuleViewController.h"

@interface SelectedRuleViewController ()

@end

@implementation SelectedRuleViewController
NSInteger passedRuleNumber;
NSInteger passedRuleValue;
AntType passedAntType;
UIColor *passedUIColor;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.selectedRule completeSetUp:self.passedAntType ruleValue:self.passedRuleValue ruleNumber:self.passedRuleNumber color:self.passedUIColor];
    self.selectedRule.editable = YES;
    [self.selectedRule setNeedsDisplay];
}

- (void)getRuleDetails:(AntType) type ruleValue:(NSInteger)ruleValue ruleNumber:(NSInteger) ruleNumber color:(UIColor*) stateColor {
    self.passedAntType = type;
    self.passedUIColor = stateColor;
    self.passedRuleValue = ruleValue;
    self.passedRuleNumber = ruleNumber;
} 

- (IBAction)deleteStateButton:(UIButton *)sender {
    NSMutableArray *statesList = [[Settings sharedInstance].statesListInGrid mutableCopy];
    if (statesList.count <= 2 ) {
        // TO DO popup warning minimum # of states
        NSLog(@"too few states");
        return;
    } else {
        [statesList removeObjectAtIndex:self.passedRuleNumber];
        [Settings sharedInstance].statesListInGrid = statesList;
        [[Settings sharedInstance] recreateGrid];
        [Settings sharedInstance].needToRebuild = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
