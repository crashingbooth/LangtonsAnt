//
//  DrumLine.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "DrumLine.h"
#import "Settings.h"

@implementation DrumLine
NSInteger const NUM_SAMPLES = 17;
AVAudioUnitReverb *reverb;
- (instancetype) initWithRegister:(NSNumber*)registerNum {
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
  
    
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"181013__snapper4298__snare-drum2"]];
     [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"406__tictacshutup__click-1-d"]];
    [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"2085__opm__kk-set1"]];
    [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"2098__opm__rs-set4"]];
    [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"266048__gis-sweden__glitchbd3"]];
    [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"267445__alienxxx__snippet-16"]];
    [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"25217__suonho__deconstruction-kit-highhat03"]];
    [self.drumPlayerArray addObject:[self createAudioPlayerWithString:@"56390__puke34__dissnares2"]];

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
