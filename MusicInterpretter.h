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
@property (nonatomic, strong) NSString *scaleName;
@property (nonatomic, strong) AbstractMusicLine *musicLine;
@property (nonatomic, strong) NSArray *scaleList;

-(id)initWithMusicLine:(AbstractMusicLine*)musicLine scale:(NSString*)scaleName;
-(void)playNoteFromDirection:(NSUInteger)direction;

@end
