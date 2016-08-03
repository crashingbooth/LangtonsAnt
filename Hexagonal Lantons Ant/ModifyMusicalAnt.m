////
////  ModifyMusicalAnt.m
////  Hexagonal Lantons Ant
////
////  Created by Jeff Holtzkener on 8/3/16.
////  Copyright © 2016 Jeff Holtzkener. All rights reserved.
////
//
//#import "ModifyMusicalAnt.h"
//
//@implementation ModifyMusicalAnt
//
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self setUpDataSource];
//    _antPicker2.delegate = self;
//    _antPicker2.dataSource = self;
//    _musicalPicker.delegate = self;
//    _musicalPicker.dataSource = self;
//    [self notSelectedBehaviour];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        [self selectedBehaviour];
//    } else {
//        [self notSelectedBehaviour];
//        ((UIView *)[_antPicker2.subviews objectAtIndex:1]).backgroundColor = [UIColor whiteColor];
//        ((UIView *)[_antPicker2.subviews objectAtIndex:2]).backgroundColor = [UIColor whiteColor];
//        ((UIView *)[_musicalPicker.subviews objectAtIndex:1]).backgroundColor = [UIColor whiteColor];
//        ((UIView *)[_musicalPicker.subviews objectAtIndex:2]).backgroundColor = [UIColor whiteColor];
//    }
//    // Configure the view for the selected state
//}
//
//- (void)selectedBehaviour{
//    [_antPicker2 setUserInteractionEnabled:YES];
//    [_musicalPicker setUserInteractionEnabled:YES];
//    [_dropButtonOutlet setAlpha:0.7];
//    [_dropButtonOutlet setUserInteractionEnabled:YES];
//}
//
//- (void)notSelectedBehaviour {
//    [_antPicker2 setUserInteractionEnabled:NO];
//    [_musicalPicker setUserInteractionEnabled:NO];
//    [_dropButtonOutlet setAlpha:0.0];
//    [_dropButtonOutlet setUserInteractionEnabled:NO];
//}
//
//- (void)setUp {
//    // requires that antNumber has been set in ModifyAntTVC
//    
//    NSAssert(self.antNumber >= 0, @"set up before antNumber set");
//    _antNumberLabel2.text = [NSString stringWithFormat:@"Ant: %ld", (long)self.antNumber + 1];
//    
//    AbstractAnt *ant = [Settings sharedInstance].antsInitialStatus[self.antNumber];
//    self.startCol = ant.currentPos.col;
//    self.startRow = ant.currentPos.row;
//    self.startDir = ant.direction;
//    
//    if 
//    self.startRegister = [Settings sharedInstance].registerArray[
//    
//    /// HERE
//    
//    [_antPicker2 selectRow:self.startCol inComponent:0 animated:NO];
//    [_antPicker2 selectRow:self.startRow inComponent:1 animated:NO];
//    [_antPicker2 selectRow:self.startDir inComponent:2 animated:NO];
//    
//}
//
//- (NSArray*) setUpDirectionDescriptions {
//    NSArray *descriptions;
//    switch ([Settings sharedInstance].antType) {
//        case FOUR_WAY:
//            descriptions = @[@"right",@"down",@"left", @"up"];
//            break;
//        case SIX_WAY:
//            descriptions = @[@"right",@"down right", @"down left" ,@"left", @"up left", @"up right"];
//            break;
//        case EIGHT_WAY:
//            descriptions = @[@"right",@"down right",@"down", @"down left" ,@"left", @"up left", @"up", @"up right"];
//            break;
//            
//        default:
//            break;
//    }
//    return descriptions;
//}
//
//- (void) setUpDataSource {
//    // descriptions
//    self.dirVals = [self setUpDirectionDescriptions];
//    
//    // cols
//    NSMutableArray *tempCols = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [Settings sharedInstance].numColsInGrid; i++) {
//        [tempCols addObject: [NSNumber numberWithInt:i]];
//    }
//    self.colVals = [tempCols copy];
//    
//    // rows
//    NSMutableArray *tempRows = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [Settings sharedInstance].numRowsInGrid; i++) {
//        [tempRows addObject: [NSNumber numberWithInt:i]];
//    }
//    self.rowVals = [tempRows copy];
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 3;
//}
//
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    switch (component) {
//        case 0:
//            return self.colVals.count;
//            break;
//        case 1:
//            return self.rowVals.count;
//            break;
//        case 2:
//            return self.dirVals.count;
//            break;
//            
//        default:
//            break;
//    }
//    return 0;
//}
//
//
//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [self stringForRow:row inComponent:component];
//}
//
//- (NSString*)stringForRow:(NSInteger)row inComponent:(NSInteger)component {
//    switch (component) {
//        case 0: // col
//            return [NSString stringWithFormat:@"%@", self.colVals[row]];
//            break;
//        case 1: // row
//            return [NSString stringWithFormat:@"%@", self.rowVals[row]];
//            break;
//        case 2: // dir
//            return [NSString stringWithFormat:@"%@", self.dirVals[row]];
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    return [NSString alloc];
//}
//
//
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* tView = (UILabel*)view;
//    if (!tView)
//    {
//        tView = [[UILabel alloc] init];
//        if (component == 2) {
//            [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
//        } else {
//            [tView setFont:[UIFont fontWithName:@"Futura-Medium" size:14]];
//        }
//        
//        [tView setTextAlignment:NSTextAlignmentCenter];
//        tView.numberOfLines = 3;
//    }
//    // Fill the label text here
//    tView.text= [self stringForRow:row inComponent:component];
//    return tView;
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//    NSInteger newRow = self.startRow;
//    NSInteger newCol = self.startCol;
//    NSInteger newDir = self.startDir;
//    
//    switch (component) {
//        case 0:
//            newCol = row;
//            break;
//        case 1:
//            newRow = row;
//            break;
//        case 2:
//            newDir = row;
//            break;
//        default:
//            break;
//    }
//    
//    [[Settings sharedInstance] modifyAnt:self.antNumber startRow:newRow startCol:newCol startDir:newDir];
//}
////}
//- (IBAction)removeButtonPress:(id)sender {
//    if ([Settings sharedInstance].antsInitialStatus.count > 1) {
//        [[Settings sharedInstance] removeAnt:self.antNumber];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"antDeleted" object:nil];  // to ModifyAntTVC
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"couldDeleteAnt" object:nil];  // to ModifyAntTVC
//    }
//}
//
//@end
