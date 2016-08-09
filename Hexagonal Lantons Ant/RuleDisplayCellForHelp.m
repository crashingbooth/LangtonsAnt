//
//  RuleDisplayCellForHelp.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/9/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayCellForHelp.h"

@implementation RuleDisplayCellForHelp {
BOOL expanded;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupAsNotSelected];
    _detailLabel2.text = [[Settings sharedInstance] getFullDescription];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"UpdateRuleCell" object:nil];
}

// add notification observer

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setupAsSelected];
        if (!expanded)
            [_rdcInternal2 setUp];
        expanded = YES;
    } else {
        [self setupAsNotSelected];
        if (expanded) {
            [_rdcInternal2 cleanUp];
        }
        expanded = NO;
        
    }
    
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"UpdateRuleCell"])
        _detailLabel2.text = [[Settings sharedInstance] getFullDescription];
}

- (void) setupAsSelected {
    [_rdcInternal2 setUserInteractionEnabled:YES];
    [_rdcInternal2 setBackgroundColor:[UIColor whiteColor]];
    [_detailLabel2 setAlpha:0.0];
    [_mainLabel2 setAlpha: 0.0];
    [_addButton2 setEnabled:YES];
    [_addButton2 setAlpha:1.0];
    
}

- (void) setupAsNotSelected {
    [_rdcInternal2 setUserInteractionEnabled:NO];
    [_rdcInternal2 setBackgroundColor:[UIColor clearColor]];
    [_detailLabel2 setAlpha:1.0];
    [_mainLabel2 setAlpha: 1.0];
    [_addButton2 setEnabled:NO];
    [_addButton2 setAlpha:0.0];
    
}

- (IBAction)addRuleButton:(UIButton *)sender {
    if ([Settings sharedInstance].statesListInGrid.count < 16) {
        [_rdcInternal2 addViewWithAnimation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"added Rule" object:nil];
    }
}

@end
