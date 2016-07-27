//
//  ModifyAntCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/27/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ModifyAntCell.h"
#import "Settings.h"
#import "Constants.h"
#import "AbstractAnt.h"
#import "GridPoint.h"

@implementation ModifyAntCell
NSInteger antNumber = -1;
NSInteger startRow = -1;
NSInteger startCol = -1;
NSInteger startDir = -1;
NSArray *colVals;
NSArray *rowVals;
NSArray *dirVals;


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpDataSource];
    _antPicker.delegate = self;
    _antPicker.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUp {
    // requires that antNumber has been set in ModifyAntTVC

    NSAssert(self.antNumber >= 0, @"set up before antNumber set");
    Settings *temp = [Settings sharedInstance];
    _antNumberLabel.text = [NSString stringWithFormat:@"Ant: %ld", (long)self.antNumber + 1];
    
    AbstractAnt *ant = [Settings sharedInstance].antsInitialStatus[self.antNumber];
    self.startCol = ant.currentPos.col;
    self.startRow = ant.currentPos.row;
    self.startDir = ant.direction;
    
    [_antPicker selectRow:self.startCol inComponent:0 animated:NO];
    [_antPicker selectRow:self.startRow inComponent:1 animated:NO];
    [_antPicker selectRow:self.startDir inComponent:2 animated:NO];

}

- (NSArray*) setUpDirectionDescriptions {
    NSArray *descriptions;
    switch ([Settings sharedInstance].antType) {
        case FOUR_WAY:
            descriptions = @[@"right",@"down",@"left", @"up"];
            break;
        case SIX_WAY:
            descriptions = @[@"right",@"down right", @"down left" ,@"left", @"up left", @"up right"];
            break;
        case EIGHT_WAY:
            descriptions = @[@"right",@"down right",@"down", @"down left" ,@"left", @"up left", @"up", @"up right"];
            break;
            
        default:
            break;
    }
    return descriptions;
}

- (void) setUpDataSource {
    // descriptions
    self.dirVals = [self setUpDirectionDescriptions];
    
    // cols
    NSMutableArray *tempCols = [[NSMutableArray alloc] init];
    for (int i = 0; i < [Settings sharedInstance].numColsInGrid; i++) {
        [tempCols addObject: [NSNumber numberWithInt:i]];
   }
    self.colVals = [tempCols copy];
    
    // rows
    NSMutableArray *tempRows = [[NSMutableArray alloc] init];
    for (int i = 0; i < [Settings sharedInstance].numRowsInGrid; i++) {
        [tempRows addObject: [NSNumber numberWithInt:i]];
    }
    self.rowVals = [tempRows copy];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.colVals.count;
            break;
        case 1:
            return self.rowVals.count;
            break;
        case 2:
            return self.dirVals.count;
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
        case 0: // col
            return [NSString stringWithFormat:@"%@", self.colVals[row]];
            break;
        case 1: // row
            return [NSString stringWithFormat:@"%@", self.rowVals[row]];
            break;
        case 2: // dir
            return [NSString stringWithFormat:@"%@", self.dirVals[row]];
            break;
            
        default:
            break;
    }
    
    
    return [NSString alloc];
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:14]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines = 3;
    }
    // Fill the label text here
    tView.text= [self stringForRow:row inComponent:component];
    return tView;
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    // set settings, calculate row
//    NSInteger newCols = [pickerData[row] integerValue];
//    [Settings sharedInstance].numColsInGrid = newCols;
//    [Settings sharedInstance].numRowsInGrid = [[Settings sharedInstance] getAppropriateNumberOfRowsForScreen: newCols];
//    [self updateLabels];
//    [[Settings sharedInstance] recreateGrid];
//    // reset settings!!!!
//}

@end
