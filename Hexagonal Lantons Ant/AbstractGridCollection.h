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
#import "Settings.h"
#import "UIViewWithPath.h"

@interface AbstractGridCollection : NSObject
@property (weak, nonatomic) UIView *parentView;
@property (weak, nonatomic) Grid *grid;
@property (nonatomic, copy) NSArray *colorListForGrid;
@property (strong, nonatomic) NSMutableArray *gridOfViews;
@property (nonatomic) CGFloat boxWidth;
@property (nonatomic) BOOL drawAsCircle;


-(id)initWithParentView:(UIView*)parentView grid:(Grid*)myGrid boxWidth:(CGFloat)boxWidthFromVC drawAsCircle:(BOOL)drawAsCircle colorList:(NSArray*) colorList;
- (void)updateOrCreateTile:(GridPoint*) gridPoint;
- (void)updateViews;
- (void)removeAllViews;
- (void)cleanGrid;

// abstract:
- (CGRect)getRectOfGridShape:(GridPoint*)gridPoint;
- (UIViewWithPath*)createTile:(CGRect)frame color:(UIColor*)color ;
@end
