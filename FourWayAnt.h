//
//  FourWayAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractAnt.h"

@interface FourWayAnt : AbstractAnt
typedef NS_ENUM(NSInteger, FourWayDirection) {
    RIGHT = 0, DOWN = 1, LEFT = 2, UP = 3
};
-(id)initWithDirection:(enum FourWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;


@end
