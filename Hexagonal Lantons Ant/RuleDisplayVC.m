//
//  RuleDisplayVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/21/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RuleDisplayVC.h"
#import "Settings.h"
#import "Constants.h"
#import "RuleDisplayView.h"

@interface RuleDisplayVC ()

@end

@implementation RuleDisplayVC
BOOL isLandscape;
NSInteger numRules;
NSMutableArray *ruleDisplayViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    numRules = [Settings sharedInstance].statesListInGrid.count;
    [self createRuleDisplayViews];
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//}

- (void)viewWillAppear:(BOOL)animated {
    [self positionRuleViews];
}

- (void)createRuleDisplayViews {
    AntType type = [Settings sharedInstance].antType;
    ruleDisplayViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < numRules; i++) {

        NSInteger num = [[Settings sharedInstance].statesListInGrid[i] integerValue];
        RuleDisplayView *rdv = [[RuleDisplayView alloc] initWithType:type ruleNumber:num];
        rdv.backgroundColor = [[Settings sharedInstance].colorList[i] colorWithAlphaComponent:0.3];
        [ruleDisplayViews addObject: rdv];
    }
}

- (void)positionRuleViews {
    // spaces will be 1/2 size of rules (rule = 2 spaces)
    // # of spaces will be # of rules + 1
    NSInteger spaces = numRules * 3 + 1;
    CGFloat spaceWidth = self.view.frame.size.width / (CGFloat) spaces;
    CGFloat yOffset = self.view.frame.size.height / 2 - spaceWidth;
    CGFloat xOffset = 0.0;
    for (RuleDisplayView * rdv in ruleDisplayViews) {
        xOffset += spaceWidth;
        CGRect rect = CGRectMake(xOffset, yOffset, spaceWidth * 2.0, spaceWidth * 2);
        rdv.frame = rect;
        [self.view addSubview:rdv];
        xOffset += (spaceWidth * 2);
         NSLog(@"called");
        
    }
   
}
@end
