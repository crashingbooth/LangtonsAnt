//
//  AbstractGridCollection.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/11/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Grid.h"

@interface AbstractGridCollection : NSObject
@property (weak, nonatomic) UIView *parentView;
@property (weak, nonatomic) Grid *grid;
@property (strong, nonatomic) NSMutableArray *gridOfViews;
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) CGFloat boxWidth;


-(id)initWithParentView:(UIView*)parentView grid:(Grid*)myGrid boxWidth:(CGFloat)boxWidthFromVC;
// abstract:
-(void)setUpInitialViews;
-(void)updateViews;
@end
