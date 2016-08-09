//
//  AboutLangtonVC2.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/8/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutLangtonVC2 : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;

@end
