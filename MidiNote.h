//
//  MidiNote.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/2/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MidiNote : NSObject
@property (nonatomic,strong) AVAudioEngine *engine;
@property (nonatomic,strong) AVAudioPlayerNode *playerNode;

-(id)initWithGMMidiNumber:(UInt8)gmMidiNumber;
-(void)playMidiNote:(NSNumber*)note onChannel:(NSNumber*)channel;
@end
