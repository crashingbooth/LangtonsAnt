//
//  RotationAwareNavigationController.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/31/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "RotationAwareNavigationController.h"

@interface RotationAwareNavigationController ()

@end

@implementation RotationAwareNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSUInteger)supportedInterfaceOrientations {
    UIViewController *top = self.topViewController;
    return top.supportedInterfaceOrientations;
}

-(BOOL)shouldAutorotate {
    UIViewController *top = self.topViewController;
    return [top shouldAutorotate];
}


@end
