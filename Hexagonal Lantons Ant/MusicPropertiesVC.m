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
NSArray *voicesListMeaning;
NSArray *panDS;
NSArray *panMeaning;
NSArray *volumeDS;
NSArray *registerDS;
NSInteger internalAntNumber;


- (void)viewDidLoad {
    [super viewDidLoad];
    _musicPropertiesPicker.delegate = self;
    _musicPropertiesPicker.dataSource = self;
  
}

- (void) viewWillAppear:(BOOL)animated {
    [_musicPropertiesPicker selectRow:self.typeStart inComponent:0 animated:NO];
    [_musicPropertiesPicker selectRow:self.voiceStart inComponent:1 animated:NO];
    [_musicPropertiesPicker selectRow:self.registerStart inComponent:2 animated:NO];
    [_musicPropertiesPicker selectRow:self.panStart inComponent:3 animated:NO];
    [_musicPropertiesPicker selectRow:self.volStart inComponent:4 animated:NO];
}



- (void)buildDataSource {
    typeListDS = @[@"music", @"drum"];
    voicesListDS = @[@"kalimba", @"piano", @"organ"];
    voicesListMeaning =@[@108, @0, @20];
    panDS = @[@"left", @"centre", @"right"];
    panMeaning = @[@-1, @0, @1];
    volumeDS = @[@0.0, @0.2, @0.4, @0.6, @0.8, @1.0];
    registerDS = @[@-2, @-1, @0, @1, @2];
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
    switch (component) {
        case 0:
            return typeListDS.count;
            break;
        case 1:
            return voicesListDS.count;  //repanval
            break;
        case 2:
            return registerDS.count;
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
    switch (component) {
        case 0:
            return typeListDS[row];
            break;
        case 1:
            return voicesListDS[row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@", registerDS[row] ];
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
    switch (component) {
        case 0:
            if (row == 0) {
                [Settings sharedInstance].musicTypeArray[internalAntNumber] = [NSNumber numberWithBool:YES];
            } else {
                [Settings sharedInstance].musicTypeArray[internalAntNumber] = [NSNumber numberWithBool:NO];
            }
            break;
        case 1:
            [Settings sharedInstance].midiVoiceArray[internalAntNumber] = voicesListMeaning[row];
            break;
        case 2:
            [Settings sharedInstance].registerArray[internalAntNumber] = registerDS[row];
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
