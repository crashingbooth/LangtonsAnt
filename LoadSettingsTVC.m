//
//  LoadSettingsTVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/18/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "LoadSettingsTVC.h"
#import "Settings.h"
#import "LoadSettingsCell.h"

@interface LoadSettingsTVC ()

@end

@implementation LoadSettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [Settings sharedInstance].fourWayPresetNames.count;
            break;
        case 1:
            return [Settings sharedInstance].sixWayPresetNames.count;
            break;
        case 2:
            return [Settings sharedInstance].eightWayPresetNames.count;
            break;
            
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoadSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadSettingsCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.settingsName.text = [Settings sharedInstance].fourWayPresetNames[indexPath.row];
            return cell;
            break;
        case 1:
            cell.settingsName.text = [Settings sharedInstance].sixWayPresetNames[indexPath.row];
            return cell;
            break;
        case 2:
            cell.settingsName.text = [Settings sharedInstance].eightWayPresetNames[indexPath.row];
            return cell;
            break;
            
        default:
        
            break;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *presetName;
    switch (indexPath.section) {
        case 0:
            presetName = [Settings sharedInstance].fourWayPresetNames[indexPath.row];
            break;
        case 1:
            presetName = [Settings sharedInstance].sixWayPresetNames[indexPath.row];
            break;
        case 2:
            presetName = [Settings sharedInstance].eightWayPresetNames[indexPath.row];
            break;
        default:
            break;
    }
    NSDictionary *dict = [Settings sharedInstance].presetDictionaries[presetName];
    [[Settings sharedInstance] extractSettingsFromDict:dict];
    
    // return directly to MainDisplayVC
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [navigationArray removeObjectAtIndex: 1];  // You can pass your index here
    self.navigationController.viewControllers = navigationArray;
    [self.navigationController popViewControllerAnimated:YES];
}




@end
