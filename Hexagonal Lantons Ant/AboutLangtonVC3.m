//
//  AboutLangtonVC3.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/8/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AboutLangtonVC3.h"

@interface AboutLangtonVC3 ()

@end

@implementation AboutLangtonVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.text1.lineBreakMode = NSLineBreakByWordWrapping;
    self.text1.numberOfLines = 0;
    
    self.text1.text = @"Although the original idea presented by Chris Langton involved a Cartesian grid, the virtual ant can also be placed on other planes(see link below).  One interesting extension is to use hexagonal cells, and allow the ant to move in any of six directions. For the six-way ant we need to tell the ant to turn left or right by either 60 degrees or 120 degrees.  I have notated this as L1 or R1 and L2, R2 respectively.  Hexagonal ants produce a number of fascinating patterns.  Below is a link to an online Heaxgonal Ant explorer from which many of my hexagonal presets were taken.\n\n I have also allowed for ants on a Cartesian grid to move diagonally, allowing for eight possible directions (of course, the four-direction ant can be expressed as a subset of this).\n It is of interest that six-direction and eight-direction ants also tend to create highways with periods ranging from 2 to over 100, with some systems being able to create multiple highways with different periods.";
}
- (IBAction)firstLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kurims.kyoto-u.ac.jp/EMIS/journals/DMTCS/pdfpapers/dmAB0105.pdf"]];
}
- (IBAction)secondLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://brtmr.de/2015/10/05/hexadecimal-langtons-ant-2.html"]];
}


@end
