//
//  EightWayAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractAnt.h"

@interface EightWayAnt : AbstractAnt
typedef NS_ENUM(NSInteger, EightWayDirection) {
    RIGHT_8 = 0, DOWN_RIGHT_8 = 1, DOWN_8 = 2, DOWN_LEFT_8 = 3, LEFT_8 = 4, UP_LEFT_8 = 5, UP_8 = 6, UP_RIGHT_8 =7
};
-(id)initWithDirection:(enum EightWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;
@end
