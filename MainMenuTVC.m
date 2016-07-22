//
//  MainMenuTVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/16/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MainMenuTVC.h"
#import "Constants.h"
#import "Settings.h"

@interface MainMenuTVC ()

@end

@implementation MainMenuTVC
NSArray *cellLabels;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillArrays];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView reloadData];
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
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
            cell.textLabel.text = cellLabels[indexPath.row];
            cell.detailTextLabel.text = [[Settings sharedInstance] getFullDescription];
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
            cell.textLabel.text = cellLabels[indexPath.row];
            cell.detailTextLabel.text = [Settings sharedInstance].name;
            break;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 1: // edit Setting
            [self performSegueWithIdentifier:@"toRuleSelectVC" sender:self];
            break;
        case 5: // load settings
            [self performSegueWithIdentifier:@"toLoadSettingsTVC" sender:self];
            break;
            
        default:
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
