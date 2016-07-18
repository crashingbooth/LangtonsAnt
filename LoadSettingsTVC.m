//
//  LoadSettingsTVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/18/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "LoadSettingsTVC.h"
#import "Settings.h"

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
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadSettingsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


@end
