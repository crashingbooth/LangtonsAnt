//
//  MusicPropertiesVC.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPropertiesVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic) NSInteger typeStart;
@property (nonatomic) NSInteger voiceStart;
@property (nonatomic) NSInteger panStart;
@property (nonatomic) NSInteger registerStart;
@property (nonatomic) NSInteger volStart;

@property (nonatomic) NSNumber *antNumberForMPVC;
@property (weak, nonatomic) IBOutlet UILabel *antNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *musicPropertiesPicker;

- (void)getStartValues;
@end
