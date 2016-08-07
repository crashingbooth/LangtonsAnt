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


-(id)initWithGMMidiNumber:(NSNumber*)gmMidiNumber root:(NSInteger)root channel:(NSNumber*)channelNum pan:(float)pan vol:(float)vol {
    self = [super init];
    if (self) {
        self.gmMidiNumber = [gmMidiNumber integerValue];
        self.channel = [channelNum integerValue];
        self.rootNote = root;
        self.pan = pan;
        self.vol = vol;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    NSError *error;
    BOOL success;
    self.engine = [[AVAudioEngine alloc] init];
    self.sampler = [[AVAudioUnitSampler alloc] init];
    [self.engine attachNode:self.sampler];
    
    
    [self.engine connect:self.sampler to:self.engine.mainMixerNode format:nil];
    
    // setup session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    success = [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    
    // start engine
    if (!self.engine.running) {
        success = [self.engine startAndReturnError:&error];
        if (!success) NSLog(@"Error staring Engline! %@\n", [error localizedDescription]);

        success = [session setActive:YES error:&error];
        if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
        
    }
    
    // load soundbank
    NSURL *soundbank = [[NSBundle mainBundle] URLForResource:@"Tim" withExtension:@"sf2"];
    if (soundbank == nil) {
        NSLog(@"no soundbank");
    }
    success = [self.sampler loadSoundBankInstrumentAtURL:soundbank program:self.gmMidiNumber
                                       bankMSB:kAUSampler_DefaultMelodicBankMSB
                                       bankLSB:kAUSampler_DefaultBankLSB
                                         error:&error];

    if (!success) NSLog(@"Error loading soundbank! %@\n", [error localizedDescription]);
    [self.sampler setStereoPan:self.pan];
    [self.sampler setMasterGain:self.vol];
    
 
}
-(void)playNote:(NSNumber*)note {
  
    UInt8 rawNote = (UInt8)[note integerValue];
    rawNote += self.rootNote;
    NSArray *info = @[[NSNumber numberWithInteger:rawNote]];
    [self.sampler startNote:rawNote withVelocity:[self mapGainToVelocity] onChannel:self.channel];
    float interval = [[Settings sharedInstance].speed floatValue] * 0.9;
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(finishNote:) userInfo:info repeats:NO];
    
//    NSLog(@"pan: %f vol %f", self.sampler.stereoPan, self.sampler.masterGain);
}

- (UInt8)mapGainToVelocity{
    // because masterGain does not seem to affect anything
    return (UInt8)(self.vol * 127.0);
}

-(void)finishNote:(NSTimer*)timer {
    NSArray *info = timer.userInfo;
    UInt8 note = [[info objectAtIndex:0] integerValue];
    [self.sampler stopNote:note onChannel:self.channel];
    
}

@end
