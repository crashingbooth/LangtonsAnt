//
//  ColorSchemeInternalView.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface ColorSchemeInternalView : UIView
@property (nonatomic, copy) NSArray* colorListForColorScheme;
@property (nonatomic) NSInteger numStatesForColorScheme;
@property (nonatomic) NSInteger colorSchemeIndex;

- (void)setUp:(NSInteger)index;
@end
