//
//  MainMenuTVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/16/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MainMenuTVC.h"

@interface MainMenuTVC ()

@end

@implementation MainMenuTVC
NSArray *cellLabels;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self fillArrays];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellLabels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 6:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SpeedCell" forIndexPath:indexPath];
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
                cell.textLabel.text = cellLabels[indexPath.row];
            break;
    }
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 6:
            return 88;
            break;
            
        default:
            return 44;
            break;
    }
}


- (void)fillArrays {
    cellLabels = @[ @"New Rules",       // 0
                    @"Edit Rules",      // 1
                    @"Dimensions",      // 2
                    @"Add Ant",         // 3
                    @"Save Settings",   // 4
                    @"Load Settings",   // 5
                    @"Speed"            // 6
                    ];
                    
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
