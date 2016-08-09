//
//  RuleDisplayCellForHelp.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/9/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayCell.h"

@interface RuleDisplayCellForHelp : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel2;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel2;

@property (weak, nonatomic) IBOutlet RuleDisplayCellInternalView *rdcInternal2;
@property (weak, nonatomic) IBOutlet UIButton *addButton2;
@end
