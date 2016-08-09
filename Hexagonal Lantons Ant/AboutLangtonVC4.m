//
//  AboutLangtonVC4.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/8/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AboutLangtonVC4.h"

@interface AboutLangtonVC4 ()

@end

@implementation AboutLangtonVC4

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.text1.lineBreakMode = NSLineBreakByWordWrapping;
    self.text1.numberOfLines = 0;
    
    self.text1.text = @"Most representations of Langton's Ant show only the states resulting from the ant's movement, but ignore the ant itself. When the music setting is turned on, the movement of each ant is mapped to a particular MIDI note or drum sound, i.e., when the ant is moving right it will play a C, when it move down-right, it will play a D, when it moves down it will play an Eb and so on. \nThe behaviour of the ant does have some interesting musical parallels, for example, repeated period cycles (highways) are essentially melodies or motifs.  Periodic cycles in the ant's world will often be able to go in different directions -this corresponds to transposiiton.  A single ant that creates a symmetical terrain (e.g., four-way LLRR) systematically creates a retrograde inversion of itself.  The tendency of ants to alternate between orderly chaotic patterns (especially when multiple ants interact with their own trails) makes for interesting musical material\n\nEach ant can have its own voice, register, volume etc, and this can be set by pressing the musical note icon in the 'Add/Modify/Delete Ants'. \nNote: the icon will only be visible when 'Music' is set to 'On' \nFurther note: Use multiple drum tracks at your own risk - this system was made primarly as a visual explorer, not as a music app" ;
}





- (IBAction)returnButton:(id)sender {
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    NSInteger count;
    for (int i = 0; i < 3; i++) {
        count = navigationArray.count;
        [navigationArray removeObjectAtIndex:count - 2 ];
    }
    self.navigationController.viewControllers = navigationArray;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
