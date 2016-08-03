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
NSMutableArray *demoViews;
NSTimeInterval timeInterval = 0.05;

- (void)viewDidLoad {
    [super viewDidLoad];
    demoViews = [[NSMutableArray alloc] init];
//    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateDemos:) userInfo:nil repeats:YES];
    
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
    
    NSString *presetName;
    NSMutableDictionary *presetDict;
    switch (indexPath.section) {
        case 0:
            presetName = [Settings sharedInstance].fourWayPresetNames[indexPath.row];
            cell.settingsName.text = [Settings sharedInstance].fourWayPresetNames[indexPath.row];
            break;
        case 1:
            presetName = [Settings sharedInstance].sixWayPresetNames[indexPath.row];
            cell.settingsName.text = [Settings sharedInstance].sixWayPresetNames[indexPath.row];
            break;
        case 2:
            presetName = [Settings sharedInstance].eightWayPresetNames[indexPath.row];
            cell.settingsName.text = [Settings sharedInstance].eightWayPresetNames[indexPath.row];
            break;
            
       
    }
    presetDict = [Settings sharedInstance].presetDictionaries[presetName] ;
    [cell.loadSettingsDemoView.demoGrid removeAllViews];
    [cell.loadSettingsDemoView setUpWithSettingsDict:presetDict];
    cell.descriptionLabel.text = [cell.loadSettingsDemoView.demo getFullDescription:presetDict];
    
    [cell.loadSettingsDemoView animate:timeInterval];
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
    [navigationArray removeObjectAtIndex: 1]; 
    self.navigationController.viewControllers = navigationArray;
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"Four Directions";
            break;
        case 1:
            sectionName = @"Six Directions";
            break;
        case 2:
            sectionName = @"Eight Directions";
            break;
        default:
            sectionName = @"INVALID";
            break;
            break;
    }
   
    [label setText:sectionName];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSettingsNeedsCleanUp" object:nil];
}







@end
