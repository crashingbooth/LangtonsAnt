//
//  AbstractAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AbstractAnt : NSObject
typedef NS_ENUM(NSInteger, HexDirection) {
    RIGHT_STRAIGHT = 0, DOWN_RIGHT = 1, DOWN_LEFT = 2, LEFT_STRAIGHT = 3, UP_LEFT = 4 , UP_RIGHT = 5
};

typedef struct {
    NSInteger row;
    NSInteger col;
} GridPoint;

@property (nonatomic) GridPoint currentPos;


@property (nonatomic) NSUInteger maxRow;
@property (nonatomic) NSUInteger maxCol;
@property (nonatomic) HexDirection direction;

-(id)initWithDirection:(enum HexDirection)direction atPos:(GridPoint)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol ;
-(void)updateDirection:(NSInteger)turnDirection;
-(GridPoint)moveToNewPosition;

@end
