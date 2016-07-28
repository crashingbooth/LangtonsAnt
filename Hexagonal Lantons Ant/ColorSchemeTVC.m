//
//  ColorSchemeTVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ColorSchemeTVC.h"
#import "Settings.h"
#import "ColorSchemeSelectCell.h"

@interface ColorSchemeTVC ()

@end

@implementation ColorSchemeTVC

- (void)viewDidLoad {
    [super viewDidLoad];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Settings masterColorList].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ColorSchemeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorSchemeFromMenu" forIndexPath:indexPath];
    [cell.colorSchemeInternalView setUp:indexPath.row];
    // Configure the cell...
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    [label setText:@"Select Color Pallette"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Settings sharedInstance].colorScheme = indexPath.row;
    [Settings sharedInstance].colorList = [[Settings sharedInstance] assignColorScheme:indexPath.row];
    [[Settings sharedInstance] recreateGrid];
     [self.navigationController popViewControllerAnimated:YES];
    
}

@end
