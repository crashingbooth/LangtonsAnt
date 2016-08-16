//
//  TimedLoop.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "TimedLoop.h"

@implementation TimedLoop
@synthesize delegate;
BOOL active;
-(id) initWithDuration:(double)duration{
    self = [super init];
    if (self) {
        self.counter = 0;
        [self getTriggerFromDuration:duration];
            }
    return self;
}

- (void) getTriggerFromDuration:(double)duration {
    self.duration = duration;
     self.trigger = (NSInteger)round(duration * 60.0);
}

- (void)startLoop {
    active = YES;
    self.counter = 0;
    self.displayLink.paused = YES;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    self.displayLink.frameInterval = 1;
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [self.displayLink addToRunLoop:runLoop forMode:NSRunLoopCommonModes];
}

- (void)stopLoop {
    active = NO;
    self.displayLink.paused = YES;
//    [self.displayLink invalidate];
//    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//    [self.displayLink removeFromRunLoop:runLoop forMode:NSRunLoopCommonModes];
    NSLog(@"%i", self.displayLink.isPaused);
}
- (void)update {
    if (active) {
        if (self.counter < self.trigger) {
            self.counter++;
        } else {
            self.counter = 0;
            [self.delegate loopBody]; // add self??
            
        }
       
    } else {
        
    NSLog(@"called not active");
           NSLog(@"%i", self.displayLink.isPaused);
    }
}




@end
