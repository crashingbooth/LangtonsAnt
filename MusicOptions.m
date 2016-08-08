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

+ (NSDictionary*) drumMapDict {
    NSDictionary *drumMapDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @[@0, @1, @2, @3, @4, @5, @6, @7],@0,
                                 @[@7, @6, @5, @4, @3, @2, @1, @0],@1,
                                 @[@8, @9, @10, @11, @12, @13, @14, @15],@2,
                                 @[@15, @14, @13, @12, @11, @10, @9, @8],@3,
                                 @[@8, @0, @9, @1, @10, @2, @11, @3],@4,
                                 @[@12, @4, @13, @5, @14, @6, @15, @7],@5
                                 ,nil];
    return drumMapDict;
}

+ (NSArray*) scalesList {
    return [MusicOptions scalesDict].allKeys;
}

+ (NSArray*) drumList {
    return @[@0, @1,@2,@3,@4,@5];
}

@end
