//
//  UIColor+UIColorFromHex.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//


/*
 from :
 http://iosdevelopertips.com/conversion/how-to-create-a-uicolor-object-from-a-hex-value.html
 */

#import "UIColor+UIColorFromHex.h"

@implementation UIColor (UIColorFromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
@end
