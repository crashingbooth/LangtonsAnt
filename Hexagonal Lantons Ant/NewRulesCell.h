//
//  NewRulesCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/25/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface NewRulesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *generateRuleLabel;
@property (weak, nonatomic) IBOutlet UIButton *fourWayButton;
@property (weak, nonatomic) IBOutlet UIButton *sixWayButton;
@property (weak, nonatomic) IBOutlet UIButton *eightWayButton;
@end
