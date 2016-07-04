//
//  AbstractAnt.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridPoint.h"
#import "MusicInterpretter.h"


@interface AbstractAnt : NSObject


@property (nonatomic, strong) GridPoint* currentPos;
@property (nonatomic) NSUInteger maxRow;
@property (nonatomic) NSUInteger maxCol;
@property (nonatomic) NSUInteger NUM_DIR; // should be class
@property (nonatomic) BOOL isMusical;
@property (nonatomic) NSInteger direction;
@property (nonatomic) NSInteger totalDir;
@property (nonatomic, strong) MusicInterpretter *musInt;

-(id)initWithPosition:(GridPoint*)currentPos  maxRow:(NSUInteger)maxRow maxCol:(NSUInteger)maxCol;
-(void)updateDirection:(NSInteger)turnDirection;
-(GridPoint*)moveToNewPosition;
-(void)addMusicInterpretter:(MusicInterpretter*)musInt;
-(GridPoint*)getNeighbourAtDirection:(NSInteger) neighbourDirection;

@end
