//
//  HexagonalAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AbstractAnt.h"
#import "Constants.h"

@interface HexagonalAnt : AbstractAnt


-(id)initWithDirection:(enum HexDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;

@end
