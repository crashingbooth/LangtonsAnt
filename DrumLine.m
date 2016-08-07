//
//  DrumLine.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "DrumLine.h"

@implementation DrumLine
NSInteger const NUM_SAMPLES = 8;
AVAudioUnitReverb *reverb;
- (instancetype) init {
    self = [super init];
    if (self) {
        
        [self createDrumPlayerArray];
    }
    return self;
}

- (void) createDrumPlayerArray {
    self.drumPlayerArray = [[NSMutableArray alloc] init];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"snare_03"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"kick_03"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"hihat_01"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"hihat_02"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"snare_01"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"snare_02"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"click_02"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"kick_05"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"click_03"]];
}

- (AVAudioPlayer*) createAudioPlayerWithString:(NSString*)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *err = [[NSError alloc] init];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (err) {
        NSLog(@"couldn't load %@", fileName);
    }
    [player prepareToPlay];
    
    return player;
}

- (void)playNote:(NSNumber*)direction {
    AVAudioPlayer *player = self.drumPlayerArray[[direction integerValue]];
       [player play];
}
                       

@end
