//
//  AntGridView.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "AbstractAnt.h"

@interface AntGridView : UIView


@property (nonatomic) CGFloat sideHeight;
@property (nonatomic) CGFloat shapeWidth;
@property (nonatomic) NSArray *colours;
@property(nonatomic, strong) Grid *grid;
@property(nonatomic, strong) NSMutableArray *paths;

-(id) initWithWidth:(CGFloat) shapeWidth andFrame:(CGRect)frame andGrid:(Grid*)grid ;
-(void)updateOnlyAntRect;
-(void)createPaths;
-(UIBezierPath*)getPathAtRow:(NSUInteger)rowNum andCol:(NSUInteger)colNum;
@end
