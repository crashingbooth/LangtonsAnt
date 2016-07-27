//
//  ModifyAntTVC.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/27/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "ModifyAntTVC.h"
#import "Settings.h"
#import "ModifyAntCell.h"
#import "AddAntCell.h"

@interface ModifyAntTVC ()


@end

@implementation ModifyAntTVC
BOOL selectionMadeInModAnt = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    selectionMadeInModAnt = NO;
}
    

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [Settings sharedInstance].antsInitialStatus.count;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
   ModifyAntCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifyAntLabelCell" forIndexPath:indexPath];
        return  cell;
    } else  if (indexPath.section == 1){
        ModifyAntCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifyAntCell" forIndexPath:indexPath];
        cell.antNumber = indexPath.row;
        [cell setUp];
        return cell;
    } else if (indexPath.section == 2) {
        AddAntCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAnt" forIndexPath:indexPath];
        return  cell;
    }

    
    return [UITableViewCell alloc];
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    if (selectedIndexPath == indexPath && indexPath.section == 1) {
        return 88;
    }  else {
        return 44;
    }
//    if (selectionMadeInModAnt && indexPath.section == 1) {
//        if (indexPath == selectedIndexPath ) {
//            return 88;
//        }
//        else {
//            return 44;
//        }
//    }
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
            selectionMadeInModAnt = YES;
            [tableView beginUpdates];
            [tableView endUpdates];
      
}





@end
