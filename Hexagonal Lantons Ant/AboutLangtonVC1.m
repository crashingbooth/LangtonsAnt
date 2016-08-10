//
//  AboutLangtonVC1.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/5/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AboutLangtonVC1.h"
#import "UIImage+animatedGIF.h"

@interface AboutLangtonVC1 ()

@end

@implementation AboutLangtonVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = url = [[NSBundle mainBundle] URLForResource:@"LangtonsAntAnimated" withExtension:@"gif"];
    self.imageViewWithGif.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
   self.topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topLabel.numberOfLines = 0;
    self.bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bottomLabel.numberOfLines = 0;
    self.scrollView.delegate = self;

    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
   
    self.topLabel.text = @"What is Langton’s Ant?\nLangton’s Ant is a remarkably simple cellular automaton that shows interesting emergent behaviour.  In its original form, it works like this: \nYou have a grid of cells, where each cell has a state (e.g., either black or white). You have an ‘ant’ that is facing one of four directions (up, down, left, or right). At each step, three things happen:\n1) The ant moves in the direction that it is facing (i.e., if it is facing left, it moves one cell to the left)\n2) If the ant lands on a white cell, its direction turns 90 degrees to the left and if it lands on a black cell it  turns 90 degrees to the right\n3) The cell that the ant landed on changes from white to black, or from black to white\n. . . and then repeat, ad infinitum.  This gif (taken from wikipedia) uses an ant icon to show the ant's direction over the first 200 steps:";
    
    self.bottomLabel.text = @"Langton’s ant starts out generating an orderly symmetrical pattern for the first 350 or so steps.  Then its behaviour appears highly chaotic for an extended period of time.  After approximately 10,000 steps, an orderly pattern suddenly emerges often referred to as a ‘highway’.  The classic Langton’s ant ‘highway’ generates a pattern with a repeating period of 104 steps.  Each time time the pattern is offset by one cell, and so it projects itself out into infinity.  This progression from orderly behaviour to chaotic to emergent orderly behaviour is one of the fascinating characteristics of Langton’s Ant. This is the 'highway' as it emerges after ~11,000 steps:";
}

- (IBAction)wikipediaLink:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://en.wikipedia.org/wiki/Langton%27s_ant"]];
}

- (IBAction)LangtonLink:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deepblue.lib.umich.edu/bitstream/handle/2027.42/26022/0000093.pdf?sequence=1&isAllowed=y"]];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}


@end
