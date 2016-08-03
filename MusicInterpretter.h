//
//  MusicInterpretter.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/2/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidiNote.h"
#import "AbstractMusicLine.h"

@interface MusicInterpretter : NSObject
@property (nonatomic, strong) NSNumber *root;
@property (nonatomic, strong) NSString *scaleName;
@property (nonatomic, strong) AbstractMusicLine *midi;
@property (nonatomic, strong) NSMutableArray *scaleList;

-(id)initWithRootNote:(NSNumber*)root withScale:(NSString*)scaleName onChannel:(NSNumber*)channel withMidi:(MidiNote*)midi;
-(void)playNoteFromDirection:(NSUInteger)direction;

@end
