//
//  SpeedCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/17/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "SpeedCell.h"



@implementation SpeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _slider.maximumValue = 0.5;
    _slider.minimumValue = 0.01;
    _slider.value =  [self setSliderFromSpeed:[Settings sharedInstance].speed];
    [self updateLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"UpdateRuleCell" object:nil];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [_slider setEnabled:YES];
        [_slider setAlpha:1.0];
    } else {
        [_slider setEnabled:NO];
        [_slider setAlpha:0.0];
    }
    
    // Configure the view for the selected state
}

- (void) updateLabel {
    _speedCellOutput.text = [NSString stringWithFormat:@"%.2f",[[Settings sharedInstance].speed floatValue] ];
}

- (IBAction)speedSliderChanged:(UISlider *)sender {
    // fast values are high, so we are reversing
    float raw = _slider.maximumValue - _slider.value +_slider.minimumValue;
    float converted = raw;
    [Settings sharedInstance].speed = [NSNumber numberWithFloat:converted];
    [self updateLabel];
}

- (float)setSliderFromSpeed:(NSNumber*)inSpeed {
    float converted = _slider.maximumValue - [inSpeed floatValue] + _slider.minimumValue;
    return converted;
    
}

- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"UpdateRuleCell"])
        _slider.value =  [self setSliderFromSpeed:[Settings sharedInstance].speed];
    [self updateLabel];
       
}



@end
