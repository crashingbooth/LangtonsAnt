//
//  ModifyAntCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/27/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyAntCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *antNumberLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *antPicker;
@property (nonatomic) NSInteger antNumber;
@property (nonatomic) NSInteger startRow;
@property (nonatomic) NSInteger startCol;
@property (nonatomic) NSInteger startDir;
@property (nonatomic, copy) NSArray *colVals;
@property (nonatomic, copy) NSArray *rowVals;
@property (nonatomic, copy) NSArray *dirVals;

- (void)setUp;
@end
