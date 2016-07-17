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
    // Initialization code
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0.02;
    _slider.value = [[Settings sharedInstance].speed floatValue];
    [self updateLabel];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateLabel {
    _speedCellOutput.text = [NSString stringWithFormat:@"%.2f",[[Settings sharedInstance].speed floatValue] ];
}

- (IBAction)speedSliderChanged:(UISlider *)sender {
//    float num = powf(4.0, _slider.value) / 15.0;
//    num -= 0.05;
//    if (num > 1.0) {
//        num = 1.0;
//    }
    float num = _slider.value;
    [Settings sharedInstance].speed = [NSNumber numberWithFloat:num];
    [self updateLabel];
}

@end
