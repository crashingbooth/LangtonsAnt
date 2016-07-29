//
//  MainDisplayViewController.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainDisplayViewController : UIViewController

typedef NS_ENUM(NSInteger, CurrentState) {
    ACTIVE = 0,
    PAUSED
};
@property (nonatomic) CurrentState currentState;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


