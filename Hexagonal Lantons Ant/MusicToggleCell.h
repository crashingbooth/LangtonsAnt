//
//  MusicToggleCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicOptions.h"

@interface MusicToggleCell :UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *musicOn;
@property (weak, nonatomic) IBOutlet UILabel *musicOnDetail;
@property (weak, nonatomic) IBOutlet UIPickerView *scalePicker;
@property (weak, nonatomic) IBOutlet UISwitch *musicOnSwitch;

@end
