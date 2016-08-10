//
//  AboutLangtonVC2.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/8/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AboutLangtonVC2.h"
#import "Settings.h"

@interface AboutLangtonVC2 ()

@end

@implementation AboutLangtonVC2 {
    BOOL selectionMade;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topLabel.numberOfLines = 0;
    self.lowerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.lowerLabel.numberOfLines = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[Settings sharedInstance] extractSettingsFromDict:[Settings sharedInstance].presetDictionaries[@"standard Langton's Ant"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"added Rule" object:nil];
    [[Settings sharedInstance] recreateGrid];
    
    self.topLabel.text = @"There is no reason to limit the number of states to two.  You could easily have, for example, three states (say, white, blue, and black - the colours are arbitrary), and the ant turns white cells blue, blue cells black, and black cells white.\nWe need to specify how each state affects the direction of the ant, i.e., turning it left (L), turning it right (R), having no change (N), or rotating it in a 180 degree U-turn (U).  The classic Langton's Ant rule system is L R, i.e., it has two states, the first causes a left rotation, the second, a right rotation.  Rules such as L R R L, and L L R R produce interesting symmteries.  LRRRRRLRLLLLLL will eventually generate fractal Sierpinski triangles.\nIn the main settings menu, if you select 'Edit Rules' you can modify the current rules system.  You can add additional states by pushing the 'add' button and you can edit or delete a state by selecting the rule.  Press 'Edit Rules' below to try this:";
    
     self.lowerLabel.text = @"We also don't need to be limited to one ant, we can also include an arbitrary number of ants.  By selecting 'Add/Modify/Remove Ants', you can control the initial location and direction of the ants.";
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

            cell = [tableView dequeueReusableCellWithIdentifier:@"helpEditSettings1" forIndexPath:indexPath];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
                if (selectedIndexPath.row == 0 && selectionMade) {
                return 88;
            } else {
                return 80;
            }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
            selectionMade = YES;
            [tableView beginUpdates];
            [tableView endUpdates];
}

@end
