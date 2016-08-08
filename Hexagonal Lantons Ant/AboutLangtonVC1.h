//
//  AboutLangtonVC1.h
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/5/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutLangtonVC1 : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewWithGif;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
