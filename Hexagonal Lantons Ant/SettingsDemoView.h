//
//  SettingsDemoView.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/18/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "AbstractGridCollection.h"

@interface SettingsDemoView : UIView
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) Settings *demo;
@property (nonatomic, strong) AbstractGridCollection *demoGrid;

- (void)setUpWithSettingsDict:(NSMutableDictionary*) dict;
- (void) update:(NSTimer*)timer;
- (void)animate:(NSTimeInterval)timeInterval;
@end
