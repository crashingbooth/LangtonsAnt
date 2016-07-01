//
//  GridPoint.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/1/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridPoint : NSObject
@property (nonatomic) NSInteger row;
@property (nonatomic )NSInteger col;

-(id)initWithRow:(NSInteger)row andCol:(NSInteger)col;
-(id)init;
@end
