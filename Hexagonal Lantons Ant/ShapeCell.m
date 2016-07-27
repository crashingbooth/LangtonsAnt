//
//  ShapeCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/27/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ShapeCell.h"
#import "Settings.h"
#import "Constants.h"

@implementation ShapeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"UpdateRuleCell" object:nil];
    [self updateButtons];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)receiveTestNotification:(NSNotification* )notification {
    if ([notification.name isEqualToString: @"UpdateRuleCell"] ) {
        [self updateButtons];
    }
}

- (void)updateButtons{
    AntType type = [Settings sharedInstance].antType;
    
    if (type == SIX_WAY) {
        [_circleOutlet setEnabled:NO];
        [_circleOutlet setAlpha:0.0];
        [_squareOutlet setEnabled:NO];
        [_squareOutlet setAlpha:0.0];
        [_hexOutlet setEnabled:YES];
        [_hexOutlet setAlpha:1.0];
    } else {
        [_circleOutlet setEnabled:YES];
        [_squareOutlet setEnabled:YES];
        [_hexOutlet setEnabled:NO];
        [_hexOutlet setAlpha:0.0];
        if ([Settings sharedInstance].defaultShape) {
            [_circleOutlet setAlpha:1.0];
            [_squareOutlet setAlpha:0.4];
        } else {
            [_circleOutlet setAlpha:0.4];
            [_squareOutlet setAlpha:1.0];
        }
    }
    [_circleOutlet setNeedsDisplay];
    [_squareOutlet setNeedsDisplay];
    [_hexOutlet setNeedsDisplay];
    
}

- (IBAction)circleAction:(UIButton *)sender {
    if (![Settings sharedInstance].defaultShape) {
        [Settings sharedInstance].defaultShape = YES;
        [[Settings sharedInstance] recreateGrid];
        [self updateButtons];
    }
}

- (IBAction)squareAction:(id)sender {
    if ([Settings sharedInstance].defaultShape) {
        [Settings sharedInstance].defaultShape = NO;
        [[Settings sharedInstance] recreateGrid];
        [self updateButtons];
    }

}

@end
