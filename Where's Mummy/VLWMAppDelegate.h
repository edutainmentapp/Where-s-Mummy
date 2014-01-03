//
//  VLWMAppDelegate.h
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
@interface VLWMAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;
-(void)musicOn;
-(void)switchMusicOnOff;
-(void)playMusic;
-(void)stopMusic;
-(BOOL)fileExists:(NSString *)fileName;
@end
