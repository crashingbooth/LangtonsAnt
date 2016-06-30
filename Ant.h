//
//  Ant.h
//  Langston's Ant
//
//  Created by Jeff Holtzkener on 6/28/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ant : NSObject
typedef NS_ENUM(NSInteger, Direction) {
    RIGHT = 0, DOWN = 1, LEFT = 2, UP = 3
};
@property (nonatomic) NSUInteger currentRow;
@property (nonatomic) NSUInteger currentCol;
@property (nonatomic) Direction direction;

-(id)initWithDirection:(enum Direction)direction atRow:(NSUInteger)currentRow atCol:(NSUInteger)currentCol;
-(void)updateDirection:(NSInteger)turnDirection;

@end
