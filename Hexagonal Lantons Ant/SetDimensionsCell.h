//
//  SetDimensionsCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/24/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetDimensionsCell : UITableViewCell<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *rowsLabel;
@property (weak, nonatomic) IBOutlet UILabel *colsValLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *columnPicker;

@end
