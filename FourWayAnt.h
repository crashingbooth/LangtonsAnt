//
//  FourWayAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractAnt.h"
#import "Constants.h"

@interface FourWayAnt : AbstractAnt

-(id)initWithDirection:(enum FourWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;


@end
