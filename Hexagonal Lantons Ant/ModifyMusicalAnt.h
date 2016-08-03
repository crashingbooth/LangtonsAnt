//
//  ModifyMusicalAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ModifyAntCell.h"
#import "Settings.h"
#import "Constants.h"
#import "AbstractAnt.h"
#import "GridPoint.h"
@interface ModifyMusicalAnt  : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *musicalPicker;

@property (weak, nonatomic) IBOutlet UIPickerView *antPicker2;


@property (weak, nonatomic) IBOutlet UIButton *dropButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *antNumberLabel2;

@property (nonatomic) NSInteger antNumber;
@property (nonatomic) NSInteger startRow;
@property (nonatomic) NSInteger startCol;
@property (nonatomic) NSInteger startDir;

@property (nonatomic) NSInteger startRegister;
@property (nonatomic) NSInteger startInst;
@property (nonatomic) NSInteger startPan;
@property (nonatomic) NSInteger startVol;


@property (nonatomic, copy) NSArray *colVals;
@property (nonatomic, copy) NSArray *rowVals;
@property (nonatomic, copy) NSArray *dirVals;


@end
