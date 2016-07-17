//
//  SpeedCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/17/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface SpeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *speedCellOutput;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end
