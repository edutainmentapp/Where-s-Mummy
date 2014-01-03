//
//  VLWMCustomProgress.m
//  Where's Mummy
//
//  Created by Vu Long on 11/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMCustomProgress.h"
#import <QuartzCore/QuartzCore.h>
@implementation VLWMCustomProgress
@synthesize activityView=_activityView;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // translucent black with rounded corners
//        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        self.layer.cornerRadius = 9.0f;
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // place the activity indicator in the center
    CGRect activityFrame = self.activityView.frame;
    activityFrame.origin = CGPointMake(
                                       floorf((CGRectGetWidth(self.frame) - CGRectGetWidth(activityFrame)) / 2.0f),
                                       floorf((CGRectGetHeight(self.frame) - CGRectGetHeight(activityFrame)) / 2.0f)
                                       );
    self.activityView.frame = activityFrame;
}

- (void) show {
    [self.activityView startAnimating];
    [super show];
}

@end
