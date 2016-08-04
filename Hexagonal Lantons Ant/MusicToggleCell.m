//
//  MusicToggleCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MusicToggleCell.h"
#import "Settings.h"


@implementation MusicToggleCell
NSString *currentScale;
NSInteger currentScaleIndex;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotification:) name:@"toggledMusic" object:nil];
    _scalePicker.delegate = self;
    _scalePicker.dataSource = self;
    [_musicOnSwitch setOn:[Settings sharedInstance].musicIsOn animated:YES];
    [self setUp];
    [self updateLabel];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self selectedBehaviour];
    } else {
        [self notSelectedBehaviour];
        ((UIView *)[_scalePicker.subviews objectAtIndex:1]).backgroundColor = [UIColor whiteColor];
        ((UIView *)[_scalePicker.subviews objectAtIndex:2]).backgroundColor = [UIColor whiteColor];
    }
}
- (void)selectedBehaviour{
    if ([Settings sharedInstance].musicIsOn) {
        [_scalePicker setUserInteractionEnabled:YES];
        [_scalePicker setAlpha:1.0];
    } else {
        [_scalePicker setUserInteractionEnabled:NO];
        [_scalePicker setAlpha:0.0];
    }
}

- (void)notSelectedBehaviour {
    [_scalePicker setUserInteractionEnabled:NO];
    if ([Settings sharedInstance].musicIsOn) {
        [_scalePicker setAlpha:1.0];
    } else {
        [_scalePicker setAlpha:0.0];
    }
}

- (void)setUp {
    // requires that antNumber has been set in ModifyAntTVC

    currentScale = [Settings sharedInstance].scaleName;
    if (currentScale == nil) {
        [Settings sharedInstance].scaleName = @"stacked3rds";
        currentScaleIndex = 0;
    } else {
        currentScaleIndex = [[MusicOptions scalesList] indexOfObject:currentScale];
    }
    [_scalePicker selectRow:currentScaleIndex inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [MusicOptions scalesList].count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [MusicOptions scalesList][row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        if (component == 2) {
            [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
        } else {
            [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:14]];
        }
        
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines = 3;
    }
    // Fill the label text here
    tView.text = [MusicOptions scalesList][row];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [Settings sharedInstance].scaleName = [MusicOptions scalesList][row];
    [[Settings sharedInstance] updateMusicStatusOfAnts];
}


- (IBAction)switchToggled:(id)sender {
    [Settings sharedInstance].musicIsOn = _musicOnSwitch.isOn;
    [[Settings sharedInstance] updateMusicStatusOfAnts];
    

    [self selectedBehaviour];
    [self updateLabel];
    
}







- (void) recievedNotification:(NSNotification*)notification {
    [self updateLabel];
}

- (void) updateLabel {
    if ([Settings sharedInstance].musicIsOn) {
        _musicOnDetail.text = @"On";
    } else {
        _musicOnDetail.text = @"Off";
    }
}

@end
