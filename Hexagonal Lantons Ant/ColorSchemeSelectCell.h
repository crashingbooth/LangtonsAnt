//
//  ColorSchemeSelectCell.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSchemeInternalView.h"

@interface ColorSchemeSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ColorSchemeInternalView *colorSchemeInternalView;

@end
