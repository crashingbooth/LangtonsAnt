//
//  Constants.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/15/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
typedef NS_ENUM(NSInteger, HexDirection) {
    RIGHT = 0, DOWN_RIGHT = 1, DOWN_LEFT = 2, LEFT = 3, UP_LEFT = 4 , UP_RIGHT = 5
};

typedef NS_ENUM(NSInteger, FourWayDirection) {
    RIGHT_4 = 0, DOWN_4 = 1, LEFT_4 = 2, UP_4 = 3
};

typedef NS_ENUM(NSInteger, EightWayDirection) {
    RIGHT_8 = 0, DOWN_RIGHT_8 = 1, DOWN_8 = 2, DOWN_LEFT_8 = 3, LEFT_8 = 4, UP_LEFT_8 = 5, UP_8 = 6, UP_RIGHT_8 =7
};

typedef NS_ENUM(NSInteger, AntType) {
    FOUR_WAY = 0, SIX_WAY, EIGHT_WAY
};

extern float loadSettingsBoxSize;

extern NSString *const nameKey;
extern NSString *const antTypeKey;
extern NSString *const statesListKey; // Array of NSInteger
extern NSString *const numRowsKey;
extern NSString *const numColsKey;
extern NSString *const speedKey;
extern NSString *const numAntsKey;
extern NSString *const shapeKey;
extern NSString *const colorSchemeKey;
extern NSString *const antDirectionKey; // Array of NSInteger
extern NSString *const antStartRowsKey; // Array of NSInteger
extern NSString *const antStartColsKey; // Array of NSInteger
extern NSString *const musicIsOnKey;
extern NSString *const musicVolArrayKey;
extern NSString *const midiVoiceArrayKey;
extern NSString *const musicLinePanArrayKey;
extern NSString *const musicScaleKey;
extern NSString *const musicTypeArrayKey;
extern NSString *const musicRegisterArrayKey;

@end
