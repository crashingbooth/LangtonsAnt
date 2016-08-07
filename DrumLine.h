//
//  DrumLine.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractMusicLine.h"
#import <AVFoundation/AVFoundation.h>

@interface DrumLine : AbstractMusicLine
@property (nonatomic) NSMutableArray *drumPlayerArray;
- (instancetype) initWithRegister:(NSNumber*)registerNum;
@end
