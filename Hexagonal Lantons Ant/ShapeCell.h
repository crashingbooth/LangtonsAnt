//
//  ShapeCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/27/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShapeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *circleOutlet;
@property (weak, nonatomic) IBOutlet UIButton *hexOutlet;
@property (weak, nonatomic) IBOutlet UIButton *squareOutlet;

@end
