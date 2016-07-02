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
float duration = 1.0;


-(id)init {
    self = [super init];
    if (self) {
        gmMIDIVoice = 0;
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

-(void)playMidiNote:(UInt8)note onChannel:(UInt8)channel {
    NSArray *info = @[[NSNumber numberWithInt:note], [NSNumber numberWithInt:channel]];
    [sampler startNote:note withVelocity:127 onChannel:channel];
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(finishNote:) userInfo:info repeats:NO];
}

-(void)finishNote:(NSTimer*)timer {
    NSArray *info = timer.userInfo;
    UInt8 note = [[info objectAtIndex:0] integerValue];
    UInt8 channel = [[info objectAtIndex:1] integerValue];
    [sampler stopNote:note onChannel:channel];

}
-(void)test {
    [self playMidiNote:60 onChannel:0];
}






@end
