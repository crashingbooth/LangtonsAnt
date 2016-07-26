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
#import "BasicCell.h"
#import "SelectedRuleViewController.h"

@interface MainMenuTVC ()

@end

@implementation MainMenuTVC
NSArray *cellLabels;
BOOL selectionMade;
BOOL stillEditingRules = NO;
NSInteger ruleNumberOfSelection = -1;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillArrays];
    stillEditingRules = NO;
    [self.tableView selectRowAtIndexPath:nil animated:NO scrollPosition:UITableViewScrollPositionTop];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"PresentEditableVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"min2StatesAlert" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView reloadData];
    if (stillEditingRules) {
        NSLog(@"autoselect");
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    
    // to prevent default selection of row 0:
    selectionMade = NO;
}

- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"PresentEditableVC"]) {
        NSDictionary *userInfo = notification.userInfo;
        ruleNumberOfSelection = [[userInfo objectForKey:@"ruleNumber"] integerValue];
        [self performSegueWithIdentifier:@"toEditableRuleVC" sender:self];
        
        
    } else if ([[notification name] isEqualToString:@"min2StatesAlert"])  {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"You need at least 2 states!"
                                      message:@"If there are fewer than two states, the ant will not be able to change state"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"toEditableRuleVC"]) {
        SelectedRuleViewController * srvc = segue.destinationViewController;
        AntType selType = [Settings sharedInstance].antType;
        NSInteger selValue = [[Settings sharedInstance].statesListInGrid[ruleNumberOfSelection] integerValue];
        UIColor *selColor = [[Settings sharedInstance].colorList[ruleNumberOfSelection] colorWithAlphaComponent:0.3];
        
        [srvc getRuleDetails:selType ruleValue:selValue ruleNumber:ruleNumberOfSelection color:selColor];
                        
  
    }
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
//    BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewRulesCell" forIndexPath:indexPath];
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"RuleDisplayCell" forIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SetDimensionCell" forIndexPath:indexPath];
//            cell.textLabel.text = cellLabels[indexPath.row];
//            cell.detailTextLabel.text = [[Settings sharedInstance] getFullDescription];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AddAntCell" forIndexPath:indexPath];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SaveSettingsCell" forIndexPath:indexPath];
            break;

        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LoadSettingsMenuCell" forIndexPath:indexPath];
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
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    switch (indexPath.row) {
        case 0:
            if (selectedIndexPath.row == 0 && selectionMade) {
                NSLog(@"Selected??");
                return 88;
            } else {
                return 44;
            }
            break;
        case 1:
            if (selectedIndexPath.row == 1) {
                return 88;
            } else {
                return 44;
            }
            break;
        case 2:
            if (selectedIndexPath.row == 2) {
                return 88;
            } else {
                return 44;
            }
            break;
        case 6:
            if (selectedIndexPath.row == 6) {
                return 88;
            } else {
                return 44;
            }
            break;
            
        default:
            return 44;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    stillEditingRules = NO;
    switch (indexPath.row) {
        case 0:
            selectionMade = YES;
            [tableView beginUpdates];
            [tableView endUpdates];
            break;
        case 1: // edit Setting
//            [self performSegueWithIdentifier:@"toRuleSelectVC" sender:self];
            stillEditingRules = YES;
            [tableView beginUpdates];
            [tableView endUpdates];
            break;
//        case 2:
//            [tableView beginUpdates];
//            [tableView endUpdates];
//            break;
        case 5: // load settings
            [self performSegueWithIdentifier:@"toLoadSettingsTVC" sender:self];
            break;
            
        default:
            [tableView beginUpdates];
            [tableView endUpdates];
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
