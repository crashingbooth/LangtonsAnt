//
//  EightWayAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractAnt.h"
#import "Constants.h"

@interface EightWayAnt : AbstractAnt

-(id)initWithDirection:(enum EightWayDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;
@end
