//
//  VLWMPlayGameView.h
//  Where's Mummy
//
//  Created by Vu Long on 01/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VLWMGameData;
@interface VLWMPlayGameView : UIViewController
@property (nonatomic, strong) IBOutlet UIImageView *hintView;
@property (strong) VLWMGameData *gameData;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end
