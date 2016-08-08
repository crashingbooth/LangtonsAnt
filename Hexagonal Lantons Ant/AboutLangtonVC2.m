//
//  AboutLangtonVC2.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/8/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AboutLangtonVC2.h"

@interface AboutLangtonVC2 ()

@end

@implementation AboutLangtonVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topLabel.numberOfLines = 0;
    
    self.topLabel.text = @"There is no reason to limit the number of states to two.  You could easily have, for example, three states (say, white, blue, and black - the colours are arbitrary), and the ant turns white cells blue, blue cells black, and black cells white.\nWe need to specify how each state affects the direction of the ant, i.e., turning it left (L), turning it right (R), having no change (N), or rotating it in a 180 degree U-turn (U).  The classic Langton's Ant rule system is L R, i.e., it has two states, the first causes a left rotation, the second, a right rotation.  Rules such as L R R L, and L L R R produce interesting symmteries\nIn the main settings menu, if you select 'Edit Rules' you can modify the current rules system.  You can add additional states by pushing the 'add' button and you can edit or delete a state by selecting the rule\n\nWe also don't need to be limited to one ant, we can also include an arbitrary number of ants.  By selecting 'Add/Modify/Remove Ants', you can control the initial location and direction of the ants";
}

@end
