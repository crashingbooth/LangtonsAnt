//
//  NewRulesCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/25/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "NewRulesCell.h"

@implementation NewRulesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self unselectedBehaviour];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self selectedBehaviour];
    } else {
        [self unselectedBehaviour];
    }
    // Configure the view for the selected state
}

- (void)selectedBehaviour {
    [_fourWayButton setEnabled:YES];
    [_sixWayButton setEnabled:YES];
    [_eightWayButton setEnabled:YES];
    [_fourWayButton setAlpha:1.0];
    [_sixWayButton setAlpha:1.0];
    [_eightWayButton setAlpha:1.0];
    
    _generateRuleLabel.text = @"Choose type:";
}
- (void)unselectedBehaviour {
    [_fourWayButton setEnabled:NO];
    [_sixWayButton setEnabled:NO];
    [_eightWayButton setEnabled:NO];
    [_fourWayButton setAlpha:0.0];
    [_sixWayButton setAlpha:0.0];
    [_eightWayButton setAlpha:0.0];

    
     _generateRuleLabel.text = @"New Rule";
    
}

- (IBAction)fourWayPress:(UIButton *)sender {
    
}
- (IBAction)sixWayPress:(id)sender {
}

- (IBAction)eightWayPress:(UIButton *)sender {
}

@end
