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
#import "ColorSchemeSelectCell.h"
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
    ColorSchemeSelectCell *colorCell;
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
            break;
            
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShapeCell" forIndexPath:indexPath];
            break;
        case 4:
            
            colorCell = [tableView dequeueReusableCellWithIdentifier:@"ColorScheme" forIndexPath:indexPath];
            [colorCell.colorSchemeInternalView setUp:[Settings sharedInstance].colorScheme];
            return colorCell;
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AddAntCell" forIndexPath:indexPath];
            break;
        case 6:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SaveSettingsCell" forIndexPath:indexPath];
            break;

        case 7:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LoadSettingsMenuCell" forIndexPath:indexPath];
            break;
        case 8:
            
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
        case 8:
            if (selectedIndexPath.row == 8) {
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
        case 4: // add ant
            [self performSegueWithIdentifier:@"toColorSchemeTVC" sender:self];
            break;
        case 5: // add ant
            [self performSegueWithIdentifier:@"toModifyAntTVC" sender:self];
            break;
        case 6: // add ant
            [self saveDialogue];
          
            break;
        case 7: // load settings
            [self performSegueWithIdentifier:@"toLoadSettingsTVC" sender:self];
            break;
            
        default:
            [tableView beginUpdates];
            [tableView endUpdates];
            break;
    }
}

- (void)saveDialogue {
    NSString *description = [[Settings sharedInstance] getFullDescription];
    NSString *name = [Settings sharedInstance].name;
    UIAlertController *saveDialogueAlert = [UIAlertController alertControllerWithTitle:@"Save Settings" message: description  preferredStyle:UIAlertControllerStyleAlert];
        [saveDialogueAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = name;
      
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    }];
    [saveDialogueAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *chosenName = saveDialogueAlert.textFields[0].text;
        [Settings sharedInstance].name = chosenName;
        [[Settings sharedInstance] saveCurrentSettings];
        NSLog(@"saving");
    }]];
    [saveDialogueAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:saveDialogueAlert animated:YES completion:nil];
    
    

}


- (void)fillArrays {
    cellLabels = @[ @"New Rules",       // 0
                    @"Edit Rules",      // 1
                    @"Dimensions",      // 2
                    @"Cell Shape",      // 3
                    @"Color Scheme",     // 4
                    @"Add Ant",         // 5
                    @"Save Settings",   // 6
                    @"Load Settings",   // 7
                    @"Speed"            // 8
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
