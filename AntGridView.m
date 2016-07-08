//
//  AntGridView.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 7/4/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "AntGridView.h"

@implementation AntGridView

CGFloat sideHeight;
CGFloat shapeWidth;
NSMutableArray *rects;



NSArray *colours;

-(id) initWithWidth:(CGFloat) shapeWidth andFrame:(CGRect)frame andGrid:(Grid*)grid {
    NSArray *clr  = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
    self.colours = clr;
    self = [super initWithFrame:frame];
    if (self) {
        self.sideHeight = shapeWidth;
        self.shapeWidth = shapeWidth;
        self.grid = grid;
//        [self setOpaque:NO];
//        [self setClearsContextBeforeDrawing:NO];
//        NSLog([NSString stringWithFormat:@"shapewidth: %.3f, height %.3f", self.shapeWidth, self.sideHeight]);
    }
    return self;
}

-(void)createRects {
    // called from init
    self.rects = [[NSMutableArray alloc] init ];
    for (int row = 0; row < self.grid.matrix.count; row++) {
        NSMutableArray *currentRow = [self.grid.matrix objectAtIndex:row];
        NSMutableArray *rectsRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < currentRow.count; col++) {
            CGRect cellRect = CGRectMake((CGFloat)col * self.shapeWidth, (CGFloat)row * self.shapeWidth,  self.shapeWidth, self.shapeWidth);
            NSValue *rectWrap = [NSValue valueWithCGRect: cellRect];
            [rectsRow addObject:rectWrap];
        }
        [self.rects addObject:rectsRow];
    }
}



-(void)updateOnlyAntRect {
    // called by the ViewController
    for (AbstractAnt *ant in self.grid.ants) {
        CGRect boundingRect =  [[[self.rects objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col] CGRectValue];
        [self setNeedsDisplayInRect:boundingRect];
    }
}

-(CGRect)getRectAtRow:(NSUInteger)rowNum andCol:(NSUInteger)colNum {
    CGRect rect = CGRectMake((CGFloat)colNum * self.shapeWidth, (CGFloat)rowNum * self.shapeWidth,  self.shapeWidth, self.shapeWidth);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    return rect;
}

- (void)drawRect:(CGRect)rect {
    if (CGRectEqualToRect(rect, self.frame)) {
        // for full screen
        for (int row = 0; row < self.grid.matrix.count; row++) {
            NSMutableArray *currentRow = [self.grid.matrix objectAtIndex:row];
            for (int col = 0; col < currentRow.count; col++) {
                CGRect currentRect = [[[self.rects objectAtIndex:row] objectAtIndex:col] CGRectValue];
//                UIBezierPath *path = [UIBezierPath bezierPathWithRect:currentRect];
                NSUInteger state = [[[self.grid.matrix objectAtIndex:row] objectAtIndex: col] integerValue];
                UIColor *currentCol = [self.colours objectAtIndex: state];
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context, [currentCol CGColor]);
                //            CGContextSetStrokeColorWithColor(context, [currentCol CGColor]);
                CGContextFillRect(context, currentRect);
                          }
        }
    } else {
        // for single cell
        for (AbstractAnt *ant in self.grid.ants) {
            NSUInteger state = [[[self.grid.matrix objectAtIndex:ant.currentPos.row ] objectAtIndex: ant.currentPos.col] integerValue];
            CGRect cellRect =  [[[self.rects objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col] CGRectValue];
            //  cellRect == rect arg
            
        UIColor *currentCol = [self.colours objectAtIndex: state];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [currentCol CGColor]);
//            CGContextSetStrokeColorWithColor(context, [currentCol CGColor]);
            CGContextFillRect(context, cellRect);
          

        }
        
    }
    
}






@end
