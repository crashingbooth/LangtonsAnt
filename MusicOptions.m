//
//  MusicOptions.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MusicOptions.h"

@implementation MusicOptions
+ (NSDictionary*) scalesDict {
    NSDictionary *scalesDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @[@0, @3, @7, @10, @12, @17, @21, @24], @"stacked3rds",
                                @[@0, @3, @5, @7, @10, @12, @15, @17],   @"pentatonic",
                                @[@0, @1, @3, @7, @8, @12, @13, @15], @"pelang",
                                @[@0, @2, @3, @5, @7, @9, @10, @12], @"dorian",
                                @[@0, @2, @4, @5, @7, @9, @11, @12], @"ionian",
                                @[@0, @2, @3, @5, @7, @10, @12, @15,@17],@"hepta",
                                @[@0, @2, @4, @6, @7, @9, @11, @12], @"lydian",
                                @[@0, @2, @4, @5, @7, @9, @10, @12], @"mixolydian",
                                @[@0, @1, @4, @5, @10, @12, @13, @16],@"iwato",
                                @[@0,@1, @2, @3, @4, @5,@6, @7],@"drum1"
                                ,nil];
    return scalesDict;
}

+ (NSArray*) scalesList {
    return [MusicOptions scalesDict].allKeys;
}

@end
