//
//  SelectedRuleViewController.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/23/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuleDisplayView.h"
#import "Constants.h"
#import "Settings.h"

@interface SelectedRuleViewController : UIViewController
@property (weak, nonatomic) IBOutlet RuleDisplayView *selectedRule;
@property (nonatomic) NSInteger passedRuleNumber;
@property (nonatomic) NSInteger passedRuleValue;
@property (nonatomic) AntType passedAntType;
@property (nonatomic) UIColor *passedUIColor;

- (void)getRuleDetails:(AntType) type ruleValue:(NSInteger)ruleValue ruleNumber:(NSInteger) ruleNumber color:(UIColor*) stateColor;
@end
