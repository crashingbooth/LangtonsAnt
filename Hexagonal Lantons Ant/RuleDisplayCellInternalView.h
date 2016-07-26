//
//  RuleDisplayCellInternalView.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/26/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "RuleDisplayView.h"
#import "Constants.h"

@interface RuleDisplayCellInternalView : UIView
@property (nonatomic) CGFloat rdcWidth;
- (void)setUp;
- (void)cleanUp;
- (void) createRuleDisplayViews;
- (void)addViewWithAnimation;
@end
