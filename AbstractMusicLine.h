//
//  AbstractMusicLine.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractMusicLine : NSObject
@property (nonatomic) float pan;
@property (nonatomic) float vol;
-(void)playNote:(NSNumber*)note;
@end
