//
//  MidiNote.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/2/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MidiNote.h"


@implementation MidiNote
AVAudioEngine *engine;
AVAudioPlayerNode *playerNode;
AVAudioUnitSampler *sampler;
NSURL *soundbank;
UInt8 melodicBank;
UInt8 gmMIDIVoice;
float duration = 0.2;


-(id)initWithGMMidiNumber:(UInt8)gmMidiNumber {
    self = [super init];
    if (self) {
        gmMIDIVoice = gmMidiNumber;
        melodicBank = (UInt8)kAUSampler_DefaultMelodicBankMSB;
        [self initAudioEngine];
    }
    return self;
}

-(void)initAudioEngine{
    engine = [[AVAudioEngine alloc] init];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self initMidi];
    
    [engine startAndReturnError:nil];
    
    [self loadSound];
}

-(void)initMidi {
    sampler = [[AVAudioUnitSampler alloc] init ];
    [engine attachNode:sampler];
    [engine connect:sampler to:engine.mainMixerNode format:nil];
    soundbank = [[NSBundle mainBundle] URLForResource:@"Tim" withExtension:@"sf2"];
    if (soundbank == nil) {
        NSLog(@"no soundbank");
    }
}

-(void)loadSound {
    [sampler loadSoundBankInstrumentAtURL:soundbank program:gmMIDIVoice bankMSB:melodicBank bankLSB:0 error:nil];
    [sampler sendProgramChange:gmMIDIVoice bankMSB:melodicBank bankLSB:0 onChannel:0];
    
}

-(void)playMidiNote:(NSNumber*)note onChannel:(NSNumber*)channel {
    NSArray *info = @[note, channel];
    UInt8 rawNote = (UInt8)[note integerValue];
    UInt8 rawChannel = (UInt8)[channel integerValue];
    [sampler startNote:rawNote withVelocity:127 onChannel:rawChannel];
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(finishNote:) userInfo:info repeats:NO];
}

-(void)finishNote:(NSTimer*)timer {
    NSArray *info = timer.userInfo;
    UInt8 note = [[info objectAtIndex:0] integerValue];
    UInt8 channel = [[info objectAtIndex:1] integerValue];
    [sampler stopNote:note onChannel:channel];

}







@end
