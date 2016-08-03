//
//  MusicToggleCell.m
//  Hexagonal Lantons Ant
//
//  Created by Jeff Holtzkener on 8/3/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

#import "MusicToggleCell.h"
#import "Settings.h"

@implementation MusicToggleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotification:) name:@"toggledMusic" object:nil];
    [self updateLabel];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) recievedNotification:(NSNotification*)notification {
    [self updateLabel];
}

- (void) updateLabel {
    if ([Settings sharedInstance].musicIsOn) {
        _musicOnDetail.text = @"On";
    } else {
        _musicOnDetail.text = @"Off";
    }
}

@end
