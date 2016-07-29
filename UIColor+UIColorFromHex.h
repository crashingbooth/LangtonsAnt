//
//  UIColor+UIColorFromHex.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorFromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
