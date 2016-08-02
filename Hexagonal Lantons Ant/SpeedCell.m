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
//    _slider.maximumValue = 15.8;
//    _slider.minimumValue = 3.2;
    _slider.maximumValue = 0.5;
    _slider.minimumValue = 0.02;
    _slider.value = [[Settings sharedInstance].speed floatValue];
    [self updateLabel];

    
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
    float raw = _slider.maximumValue - _slider.value +_slider.minimumValue;
    
    
//    float converted = powf(raw, 2.0) * 0.002;
    float converted = raw;
    
    NSLog(@"original: %f raw: %f, converted %f",_slider.value,raw, converted);
//    float num = powf(4., _slider.value) / 15.0;
//    num -= 0.05;
//    if (num > 1.0) {
//        num = 1.0;
//    }

    [Settings sharedInstance].speed = [NSNumber numberWithFloat:converted];
    [self updateLabel];
}

@end
