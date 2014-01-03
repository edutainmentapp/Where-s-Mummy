//
//  VLWMCustomProgress.h
//  Where's Mummy
//
//  Created by Vu Long on 11/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//
#import "VLWMPopup.h"
#import <UIKit/UIKit.h>
@interface VLWMCustomProgress : VLWMPopup
@property(nonatomic, readonly) UIActivityIndicatorView *activityView;
- (id) initWithFrame:(CGRect)frame;
@end
