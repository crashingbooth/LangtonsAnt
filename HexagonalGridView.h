//
//  HexagonalGridView.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 6/29/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "AbstractAnt.h"



@interface HexagonalGridView : UIView
@property (nonatomic) CGFloat sideHeight;
@property (nonatomic) CGFloat shapeWidth;
@property (nonatomic) NSArray *colours;
@property(nonatomic, strong) Grid *grid;

-(id) initWithWidth:(CGFloat) shapeWidth andFrame:(CGRect)frame andGrid:(Grid*)grid ;
@end
