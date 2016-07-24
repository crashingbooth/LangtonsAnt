//
//  LoadSettingsCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/18/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsDemoView.h"

@interface LoadSettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *settingsName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet SettingsDemoView *loadSettingsDemoView;

@end
