//
//  SetDimensionsCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/24/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "SetDimensionsCell.h"
#import "Settings.h"

@implementation SetDimensionsCell
NSMutableArray *pickerData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _columnPicker.delegate = self;
    _columnPicker.dataSource = self;
    _colsValLabel.textAlignment = NSTextAlignmentLeft;
  
    pickerData = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 16; i++) {
        [pickerData addObject:[NSNumber numberWithInt:i * 10]];
        [self updateLabels];
    }
    NSInteger rowNumber = ([Settings sharedInstance].numColsInGrid / 10) - 1;
    [_columnPicker selectRow:rowNumber inComponent:0 animated:NO];
    
}

- (void)updateLabels{
    _colsValLabel.text = [ NSString stringWithFormat:@"%li", [Settings sharedInstance].numColsInGrid];
    _rowsLabel.text = [ NSString stringWithFormat:@"Rows: %li", [Settings sharedInstance].numRowsInGrid];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [_colsValLabel setAlpha:0.0];
        [_columnPicker setAlpha:1.0];
        NSLog(@"selected");
    } else {
        [self updateLabels];
        [_colsValLabel setAlpha:0.0];
        [_columnPicker setAlpha:1.0];

    }

    // Configure the view for the selected state
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return pickerData[row];
    return [NSString stringWithFormat:@" %@",pickerData[row] ];
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:14]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    tView.text=[NSString stringWithFormat:@" %@",pickerData[row] ];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // set settings, calculate row
    NSInteger newCols = [pickerData[row] integerValue];
    [Settings sharedInstance].numColsInGrid = newCols;
    [Settings sharedInstance].numRowsInGrid = [[Settings sharedInstance] getAppropriateNumberOfRowsForScreen: newCols];
    [self updateLabels];
    [[Settings sharedInstance] recreateGrid];
    // reset settings!!!!
}


@end
