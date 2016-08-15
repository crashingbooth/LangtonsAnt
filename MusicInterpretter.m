//
//  MusicInterpretter.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/2/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MusicInterpretter.h"
#import "Settings.h"


@implementation MusicInterpretter
NSNumber *root;
NSString *scaleName;
NSArray *scaleList;
-(id)initWithMusicLine:(AbstractMusicLine*)musicLine scale:(NSString*)scaleName {
    self = [super init];
    if (self) {
        self.scaleName = scaleName;
        self.musicLine = musicLine;
        [self mapSounds];
        
    }
    return self;
}


-(void)playNoteFromDirection:(NSUInteger)direction {
    NSNumber *note = self.scaleList[direction];
    [self.musicLine playNote:note];
}

- (void) mapSounds{
    NSDictionary *mapping;
    if ([self.musicLine isMemberOfClass:[DrumPlayerLine class]]) {
        mapping = [MusicOptions drumMapDict];
        NSNumber *regIndex = [Settings sharedInstance].registerArray[self.musicLine.antIndex];
        self.scaleList = mapping[regIndex];
    } else {
        mapping = [MusicOptions scalesDict];
        self.scaleList = mapping[self.scaleName];
    }
}



@end
