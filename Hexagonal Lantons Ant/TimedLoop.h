//
//  TimedLoop.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TimedLoop;
@protocol TimedLoopDelegate <NSObject>

-(void) loopBody;

@end
@interface TimedLoop : NSObject
@property (nonatomic) NSInteger trigger;
@property (nonatomic) NSInteger counter;
@property (nonatomic )double duration;
@property (nonatomic) CADisplayLink *displayLink;
@property(nonatomic, weak) id <TimedLoopDelegate> delegate;

-(id) initWithDuration:(double)duration;
- (void)stopLoop;
- (void)startLoop;
- (void) getTriggerFromDuration:(double)duration;

@end
