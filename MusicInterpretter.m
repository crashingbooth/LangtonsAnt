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
NSMutableArray *scaleDict;
-(id)initWithRootNote:(NSNumber*)root withScale:(NSString*)scaleName onChannel:(NSNumber*)channel withMidi:(MidiNote*)midi {
    self = [super init];
    if (self) {
        self.root = root;
        self.scaleName = scaleName;
        self.scaleList = [[NSMutableArray alloc] init];
        [self initScaleList];
        self.channel = channel;
        self.midi = midi;
        
    }
    return self;
}

-(void)initScaleList{
    NSArray *pentatonic = @[@0, @3, @5, @7, @10, @12, @15, @17];
    NSArray *pelang = @[@0, @1, @3, @7, @8, @12, @13, @15];
    NSArray *dorian = @[@0, @2, @3, @5, @7, @9, @10, @12];
    NSArray *intervals;
    
    if ([self.scaleName isEqualToString:@"pentatonic"]) {
        intervals = pentatonic;
    } else if ([self.scaleName isEqualToString:@"pelang"]) {
        intervals = pelang;
    } else if ([self.scaleName isEqualToString:@"dorian"]) {
        intervals = dorian;
    }
    
    for (int i = 0; i < intervals.count; i++) {
        NSInteger rawNote = [[intervals objectAtIndex:i] integerValue] + [self.root integerValue];
        NSNumber *note = [NSNumber numberWithInt:rawNote];
       
        [self.scaleList addObject:note];
    }
}

-(void)playNoteFromDirection:(NSUInteger)direction {
    NSNumber *note = [self.scaleList objectAtIndex:direction];
    [self.midi playMidiNote:note onChannel:self.channel];
}



@end
