//
//  RuleDisplayCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/25/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuleDisplayCellInternalView.h"

@interface RuleDisplayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@property (weak, nonatomic) IBOutlet RuleDisplayCellInternalView *rdcInternal;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
