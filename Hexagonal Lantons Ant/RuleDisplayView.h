//
//  RuleDisplayView.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/20/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Settings.h"

@interface RuleDisplayView : UIView
@property (nonatomic) AntType type;
@property (nonatomic) NSInteger ruleValue;
@property (nonatomic) NSInteger ruleNumber;
@property (nonatomic, strong) UIImageView *controlArrow;
@property (nonatomic, strong) UIImageView *guideArrow;
@property (nonatomic, strong) UILabel *stateNumLabel;
@property (nonatomic, strong) UILabel *stateValLabel;
@property (nonatomic, strong) UIColor *stateColor;
@property (nonatomic) BOOL editable;
- (id)initWithType:(AntType) type ruleValue:(NSInteger)ruleValue ruleNumber:(NSInteger) ruleNumber color:(UIColor*) stateColor;
- (void) positionControlArrow ;
@end
