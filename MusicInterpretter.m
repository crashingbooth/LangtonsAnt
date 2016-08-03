//
//  MusicInterpretter.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/2/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MusicInterpretter.h"


@implementation MusicInterpretter
NSNumber *root;
NSString *scaleName;
NSArray *scaleList;
-(id)initWithMusicLine:(AbstractMusicLine*)musicLine scale:(NSString*)scaleName {
    self = [super init];
    if (self) {
        self.scaleName = scaleName;
        self.scaleList = [[NSArray alloc] init];
        [self initScaleList];
        self.musicLine = musicLine;
        
    }
    return self;
}

-(void)initScaleList{
    NSArray *pentatonic = @[@0, @3, @5, @7, @10, @12, @15, @17];
    NSArray *pelang = @[@0, @1, @3, @7, @8, @12, @13, @15];
    NSArray *dorian = @[@0, @2, @3, @5, @7, @9, @10, @12];
    NSArray *ionian = @[@0, @2, @4, @5, @7, @9, @11, @12];
    NSArray *hepta = @[@0, @2, @3, @5, @7, @10, @12, @15,@17];
    NSArray *stacked3rds = @[@0, @3, @7, @10, @12, @17, @21, @24];
    NSArray *lydian = @[@0, @2, @4, @6, @7, @9, @11, @12];
    NSArray *mixolydian = @[@0, @2, @4, @5, @7, @9, @10, @12];
    NSArray *iwato = @[@0, @1, @4, @5, @10, @12, @13, @16];
    
    NSArray *intervals;
    
    if ([self.scaleName isEqualToString:@"pentatonic"]) {
        intervals = pentatonic;
    } else if ([self.scaleName isEqualToString:@"pelang"]) {
        intervals = pelang;
    } else if ([self.scaleName isEqualToString:@"dorian"]) {
        intervals = dorian;
    }  else if ([self.scaleName isEqualToString:@"iwato"]) {
        intervals = iwato;
    }  else if ([self.scaleName isEqualToString:@"ionian"]) {
        intervals = ionian;
    }  else if ([self.scaleName isEqualToString:@"mixolydian"]) {
        intervals = mixolydian;
    } else if ([self.scaleName isEqualToString:@"lydian"]) {
        intervals = lydian;
    }    else if ([self.scaleName isEqualToString:@"hepta"]) {
        intervals = hepta;
    }  else if ([self.scaleName isEqualToString:@"stacked3rds"]) {
        intervals = stacked3rds;
        
    }
    
    self.scaleList = intervals;
   
}

-(void)playNoteFromDirection:(NSUInteger)direction {
    NSNumber *note = self.scaleList[direction];
    [self.musicLine playNote:note];
}



@end
