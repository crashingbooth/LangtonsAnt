//
//  LoadSettingsMenuCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/25/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "LoadSettingsMenuCell.h"
#import "Settings.h"

@implementation LoadSettingsMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _detailsLabel.text = [Settings sharedInstance].name ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"UpdateRuleCell" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"UpdateRuleCell"])
        _detailsLabel.text = [Settings sharedInstance].name;
}

@end
