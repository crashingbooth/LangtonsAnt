
//
//  RuleDisplayCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/25/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayCell.h"
#import "Settings.h"

@implementation RuleDisplayCell
BOOL expanded;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupAsNotSelected];
    _detailLabel.text = [[Settings sharedInstance] getFullDescription];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"UpdateRuleCell" object:nil];
}

// add notification observer

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setupAsSelected];
        if (!expanded)
            [_rdcInternal setUp];
        expanded = YES;
    } else {
        [self setupAsNotSelected];
        if (expanded) {
            [_rdcInternal cleanUp];
        }
        expanded = NO;

    }
    

}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"UpdateRuleCell"])
       _detailLabel.text = [[Settings sharedInstance] getFullDescription];
}

- (void) setupAsSelected {
    [_rdcInternal setUserInteractionEnabled:YES];
    [_rdcInternal setBackgroundColor:[UIColor whiteColor]];
    [_detailLabel setAlpha:0.0];
    [_mainLabel setAlpha: 0.0];
    [_addButton setEnabled:YES];
    [_addButton setAlpha:1.0];
    
}

- (void) setupAsNotSelected {
    [_rdcInternal setUserInteractionEnabled:NO];
    [_rdcInternal setBackgroundColor:[UIColor clearColor]];
    [_detailLabel setAlpha:1.0];
    [_mainLabel setAlpha: 1.0];
    [_addButton setEnabled:NO];
    [_addButton setAlpha:0.0];
    
}

- (IBAction)addRuleButton:(UIButton *)sender {
    if ([Settings sharedInstance].statesListInGrid.count < 16) {
        [_rdcInternal addViewWithAnimation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"added Rule" object:nil];
    }    
}

@end
