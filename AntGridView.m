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
NSMutableArray *paths;



NSArray *colours;

-(id) initWithWidth:(CGFloat) shapeWidth andFrame:(CGRect)frame andGrid:(Grid*)grid {
    NSArray *clr  = @[[UIColor whiteColor],[UIColor darkGrayColor], [UIColor blueColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor blackColor],  [UIColor blueColor], [UIColor purpleColor], [UIColor lightGrayColor],[UIColor darkGrayColor], [UIColor whiteColor]];
    self.colours = clr;
    self = [super initWithFrame:frame];
    if (self) {
        self.sideHeight = shapeWidth;
        self.shapeWidth = shapeWidth;
        self.grid = grid;

        NSLog([NSString stringWithFormat:@"shapewidth: %.3f, height %.3f", self.shapeWidth, self.sideHeight]);
    }
    return self;
}

-(void)createPaths {
    self.paths = [[NSMutableArray alloc] init ];
    for (int row = 0; row < self.grid.matrix.count; row++) {
        NSMutableArray *currentRow = [self.grid.matrix objectAtIndex:row];
        NSMutableArray *pathsRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < currentRow.count; col++) {
            UIBezierPath *path = [self getPathAtRow:row andCol:col];
            [pathsRow addObject:path];
        }
        [self.paths addObject:pathsRow];
    }
}



-(void)updateOnlyAntRect {
    for (AbstractAnt *ant in self.grid.ants) {
        UIBezierPath *path = [[self.paths objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col];
        CGRect boundingRect = CGRectMake(path.bounds.origin.x, path.bounds.origin.y, path.bounds.size.width, path.bounds.size.height);
        [self setNeedsDisplayInRect:boundingRect];
    }
    
}

-(UIBezierPath*)getPathAtRow:(NSUInteger)rowNum andCol:(NSUInteger)colNum {
    CGRect rect = CGRectMake((CGFloat)colNum * self.shapeWidth, (CGFloat)rowNum * self.shapeWidth,  self.shapeWidth, self.shapeWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    return path;
}

- (void)drawRect:(CGRect)rect {
    if (rect.size.width == self.frame.size.width) {
        NSLog(@"all");
        for (int row = 0; row < self.grid.matrix.count; row++) {
            NSMutableArray *currentRow = [self.grid.matrix objectAtIndex:row];
            for (int col = 0; col < currentRow.count; col++) {
                UIBezierPath *path = [[self.paths objectAtIndex:row] objectAtIndex:col];
                NSUInteger state = [[[self.grid.matrix objectAtIndex:row] objectAtIndex: col] integerValue];
                UIColor *currentCol = [self.colours objectAtIndex: state];
                [currentCol setFill];
                [currentCol setStroke];
                path.lineWidth = 1;
                [path stroke];
                
                [path fill];
            }
            
        }
        
    } else {
        //        NSLog(@"ant only");
        for (AbstractAnt *ant in self.grid.ants) {
            
            NSUInteger state = [[[self.grid.matrix objectAtIndex:ant.currentPos.row ] objectAtIndex: ant.currentPos.col] integerValue];
            // try to make new path and reinsert it into paths
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            [[paths objectAtIndex:ant.currentPos.row ]replaceObjectAtIndex:ant.currentPos.col withObject:path];
//            [[self.paths objectAtIndex:ant.currentPos.row] objectAtIndex:ant.currentPos.col];
            UIColor *currentCol = [self.colours objectAtIndex: state];
            self.backgroundColor = [UIColor clearColor];
            [currentCol setFill];
            [currentCol setStroke];
            path.lineWidth = 2;
             [path fill];
            [path stroke];
           
            NSLog([NSString stringWithFormat:@"col: %li, row: %li startPath: %.4f,startRect: %.4f, end: %.4f", ant.currentPos.col, ant.currentPos.row,path.bounds.origin.y, rect.origin.y, path.bounds.size.height,  rect.size.height]);
        }
        
    }
    
    
}






@end
