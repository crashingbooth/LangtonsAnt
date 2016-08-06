//
//  MusicPropertiesVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MusicPropertiesVC.h"
#import "Settings.h"

@interface MusicPropertiesVC ()

@end

@implementation MusicPropertiesVC
NSArray *typeListDS;
NSArray *voicesListDS;
NSArray *drumVoiceListDS;
NSArray *voicesListMeaning;
NSArray *panDS;
NSArray *panMeaning;
NSArray *volumeDS;
NSArray *registerDS;
NSArray *drumRegisterDS;
NSInteger internalAntNumber;


- (void)viewDidLoad {
    [super viewDidLoad];
    _musicPropertiesPicker.delegate = self;
    _musicPropertiesPicker.dataSource = self;
  
}

- (void) viewWillAppear:(BOOL)animated {
    _antNumberLabel.text = [NSString stringWithFormat:@"Ant Number %li", [self.antNumberForMPVC integerValue] + 1 ];
    [_musicPropertiesPicker selectRow:self.typeStart inComponent:0 animated:NO];
    [_musicPropertiesPicker selectRow:self.voiceStart inComponent:1 animated:NO];
    [_musicPropertiesPicker selectRow:self.registerStart inComponent:2 animated:NO];
    [_musicPropertiesPicker selectRow:self.panStart inComponent:3 animated:NO];
    [_musicPropertiesPicker selectRow:self.volStart inComponent:4 animated:NO];
    [self updateDrumToggle];
}



- (void)buildDataSource {
    typeListDS = @[@"music", @"drum"];
    voicesListDS = @[@"kalimba", @"piano", @"organ",@"ocarina", @"calliope synth", @"clavi"];
    drumVoiceListDS = @[@"n/a"];
    voicesListMeaning =@[@108, @0, @17, @79, @83, @7];
    panDS = @[@"left", @"centre", @"right"];
    panMeaning = @[@-1, @0, @1];
    volumeDS = @[@0.0, @0.2, @0.4, @0.6, @0.8, @1.0];
    registerDS = @[@-2, @-1, @0, @1, @2];
    drumRegisterDS = @[@-2, @-1, @0, @1, @2];
}

- (void) updateDrumToggle {
     BOOL isMelodic = [[[Settings sharedInstance].musicTypeArray objectAtIndex:[self.antNumberForMPVC integerValue]] boolValue];
    if (isMelodic) {
        _registerLabel.text = @"register";
        
    } else {
        _registerLabel.text = @"drum kit num.";
    }
    [_musicPropertiesPicker reloadAllComponents];
    if (isMelodic) {
        NSNumber *voiceVal = [Settings sharedInstance].midiVoiceArray[internalAntNumber];
        self.voiceStart = [voicesListMeaning indexOfObject:voiceVal];
        [_musicPropertiesPicker selectRow:self.voiceStart inComponent:1 animated:NO];
    }
    
}

- (void)getStartValues {
    [self buildDataSource];
    if (self.antNumberForMPVC) {
        internalAntNumber = [self.antNumberForMPVC integerValue];

        NSNumber *typeVal = [Settings sharedInstance].musicTypeArray[internalAntNumber];
        NSNumber *voiceVal = [Settings sharedInstance].midiVoiceArray[internalAntNumber];
        NSNumber *panVal = [Settings sharedInstance].panArray[internalAntNumber];
        NSNumber *registerVal = [Settings sharedInstance].registerArray[internalAntNumber];
        NSNumber *volVal = [Settings sharedInstance].volArray[internalAntNumber];
        
        if ([typeVal boolValue]) {
            self.typeStart = 0;
        } else {
            self.typeStart = 1;
        }
        
        self.voiceStart = [voicesListMeaning indexOfObject:voiceVal];
        self.panStart = [panMeaning indexOfObject:panVal];
        self.registerStart = [registerDS indexOfObject:registerVal];
        self.volStart = [volumeDS indexOfObject:volVal];
        

    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    BOOL isMelodic = [[[Settings sharedInstance].musicTypeArray objectAtIndex:[self.antNumberForMPVC integerValue]] boolValue];
    switch (component) {
        case 0:
            return typeListDS.count;
            break;
        case 1:
            if (isMelodic) {
                return voicesListDS.count;
            } else {
                return drumVoiceListDS.count;
            }
            break;
        case 2:
            if (isMelodic) {
                return registerDS.count;
            } else {
                return drumRegisterDS.count;
            }
            break;
           
        case 3:
            return panDS.count;
            break;
        case 4:
            return volumeDS.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self stringForRow:row inComponent:component];
}

- (NSString*)stringForRow:(NSInteger)row inComponent:(NSInteger)component {
    BOOL isMelodic = [[[Settings sharedInstance].musicTypeArray objectAtIndex:[self.antNumberForMPVC integerValue]] boolValue];
    switch (component) {
        case 0:
            return typeListDS[row];
            break;
        case 1:
            if (isMelodic) {
                return voicesListDS[row];
            } else {
                return drumVoiceListDS[row];
            }
            break;
        case 2:
            if (isMelodic) {
                 return [NSString stringWithFormat:@"%@", registerDS[row] ];
            } else {
                 return [NSString stringWithFormat:@"%@", drumRegisterDS[row] ];
            }
            break;
        case 3:
            return [NSString stringWithFormat:@"%@",panDS[row] ];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@", volumeDS[row] ];
            break;
            
        default:
            break;
    }
    return 0;
    
    
    return [NSString alloc];
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
    tView.text= [self stringForRow:row inComponent:component];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    BOOL isMelodic = [[[Settings sharedInstance].musicTypeArray objectAtIndex:[self.antNumberForMPVC integerValue]] boolValue];
    switch (component) {
        case 0:
            if (row == 0) {
                [Settings sharedInstance].musicTypeArray[internalAntNumber] = [NSNumber numberWithBool:YES];
            } else {
                [Settings sharedInstance].musicTypeArray[internalAntNumber] = [NSNumber numberWithBool:NO];
            }
            [self updateDrumToggle];
            break;
        case 1:
            [Settings sharedInstance].midiVoiceArray[internalAntNumber] = voicesListMeaning[row];
            break;
        case 2:
            if (isMelodic) {
                [Settings sharedInstance].registerArray[internalAntNumber] = registerDS[row];
            } else {
                [Settings sharedInstance].registerArray[internalAntNumber] = drumRegisterDS[row];
            }
            break;
        case 3:
            [Settings sharedInstance].panArray[internalAntNumber] = panMeaning[row];
            break;
        case 4:
            [Settings sharedInstance].volArray[internalAntNumber] = volumeDS[row];
            break;
            
        default:
            break;
    }

}






@end
