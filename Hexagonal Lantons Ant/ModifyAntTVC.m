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
#import "MusicPropertiesVC.h"

@interface ModifyAntTVC ()


@end

@implementation ModifyAntTVC
BOOL selectionMadeInModAnt = NO;
NSInteger selectedAntNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:@"antDeleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:@"couldntDeleteAnt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:@"openMusicProperties" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    selectionMadeInModAnt = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[Settings sharedInstance] recreateGrid];
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
        return 100;
    }  else {
        return 44;
    }

    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
        
            break;
        case 1:
            selectionMadeInModAnt = YES;
            break;
        case 2:
            if ([Settings sharedInstance].settingsGrid.ants.count < 16) {
                [[Settings sharedInstance] addAnt];
                if ([Settings sharedInstance].musicIsOn) {
                    [[Settings sharedInstance] updateMusicStatusOfAnts];
                }
                [tableView reloadData];
            } else {
                [self cantAddAntAlert];
            }
        default:
            break;
    }

        [tableView beginUpdates];
        [tableView endUpdates];
      
}

- (void)cantAddAntAlert {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Too many ants!"
                                  message:@"You probably don't really need more than 16 ants"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cantDeleteAntAlert {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"You need at least 1 ant!"
                                  message:@"Without at least one ant, nothing will happen"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)notificationRecieved:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"antDeleted"]) {
        [self.tableView reloadData];
    } else if ([notification.name isEqualToString:@"couldntDeleteAnt"]) {
        [self cantDeleteAntAlert];
    }  else if ([notification.name isEqualToString:@"openMusicProperties"]) {
        NSDictionary *userInfo = notification.userInfo;
        selectedAntNum = [userInfo[@"antNumberKey"] integerValue];
        [self performSegueWithIdentifier:@"toMusicPropertiesVC" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMusicPropertiesVC"]) {
        MusicPropertiesVC *mpVC = segue.destinationViewController;
        mpVC.antNumberForMPVC = [NSNumber numberWithInteger: selectedAntNum];
        [mpVC getStartValues];
    }
}







@end
