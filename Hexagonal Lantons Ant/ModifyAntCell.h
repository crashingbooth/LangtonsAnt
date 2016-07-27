//
//  ModifyAntCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/27/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyAntCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *antNumberLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *antPicker;

@end
