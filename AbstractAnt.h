//
//  AbstractAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridPoint.h"


@interface AbstractAnt : NSObject
typedef NS_ENUM(NSInteger, HexDirection) {
    RIGHT = 0, DOWN_RIGHT = 1, DOWN_LEFT = 2, LEFT = 3, UP_LEFT = 4 , UP_RIGHT = 5
};



@property (nonatomic, strong) GridPoint* currentPos;


@property (nonatomic) NSUInteger maxRow;
@property (nonatomic) NSUInteger maxCol;
@property (nonatomic) HexDirection direction;
@property (nonatomic) NSInteger totalDir;

-(id)initWithDirection:(enum HexDirection)direction atPos:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol ;
-(void)updateDirection:(NSInteger)turnDirection;
-(GridPoint*)moveToNewPosition;

@end
