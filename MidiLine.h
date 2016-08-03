//
//  MidiLine.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "AbstractMusicLine.h"

@interface MidiLine : AbstractMusicLine
@property (nonatomic) AVAudioEngine *engine;
@property (nonatomic) AVAudioUnitSampler *sampler;
@property UInt8 gmMidiNumber;
@property UInt8 channel;

@end
