//
//  MidiLine.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MidiLine.h"

@implementation MidiLine

AVAudioEngine *engine;
AVAudioUnitSampler *sampler;
UInt8 gmMidiNumber;
UInt8 channel;
UInt8 rootNote;


-(id)initWithGMMidiNumber:(NSNumber*)gmMidiNumber root:(NSInteger)root channel:(NSNumber*)channelNum pan:(float)pan {
    self = [super init];
    if (self) {
        self.gmMidiNumber = [gmMidiNumber integerValue];
        self.channel = [channelNum integerValue];
        self.rootNote = root;
        self.pan = pan;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    NSError *err = [[NSError alloc] init];
    
    self.engine = [[AVAudioEngine alloc] init];
    self.sampler = [[AVAudioUnitSampler alloc] init];
    [self.engine attachNode:self.sampler];
    
    [self.engine connect:self.sampler to:self.engine.mainMixerNode format:nil];
    
    // setup session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&err];
    if (err != nil) NSLog(@"error on session setup");
    
    // start engine
    if (!self.engine.running) {
        [self.engine startAndReturnError:&err];
        if (err != nil) NSLog(@"error on start engine");
        [session setActive:YES error:&err];
        if (err != nil) NSLog(@"error setting session active");
        
    }
    
    // load soundbank
    NSURL *soundbank = [[NSBundle mainBundle] URLForResource:@"Tim" withExtension:@"sf2"];
    if (soundbank == nil) {
        NSLog(@"no soundbank");
    }
    [self.sampler loadSoundBankInstrumentAtURL:soundbank program:self.gmMidiNumber
                                       bankMSB:kAUSampler_DefaultMelodicBankMSB
                                       bankLSB:kAUSampler_DefaultBankLSB
                                         error:&err];
    
    [self.sampler setStereoPan:self.pan];
 
}
-(void)playNote:(NSNumber*)note {
  
    UInt8 rawNote = (UInt8)[note integerValue];
    rawNote += self.rootNote;
    NSArray *info = @[[NSNumber numberWithInteger:rawNote]];
    [self.sampler startNote:rawNote withVelocity:127 onChannel:self.channel];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(finishNote:) userInfo:info repeats:NO];
}

-(void)finishNote:(NSTimer*)timer {
    NSArray *info = timer.userInfo;
    UInt8 note = [[info objectAtIndex:0] integerValue];
    [self.sampler stopNote:note onChannel:self.channel];
    
}

@end
