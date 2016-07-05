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
    RIGHT_4 = 0, DOWN_4 = 1, LEFT_4 = 2, UP_4 = 3
};
-(id)initWithDirection:(enum FourWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;


@end
