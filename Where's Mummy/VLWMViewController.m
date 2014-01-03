//
//  VLWMViewController.m
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMViewController.h"
#import "VLWMPlayListView.h"
#import "VLWMAppDelegate.h"
#import "VLWMGameListView.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVFoundation.h>
//@interface VLWMViewController ()
//{
//}
//@end
@implementation VLWMViewController
static int noOfColum;
static int noOfRow;
//static BOOL blFirstLoad = YES;
- (void)viewDidLoad
{
    [super viewDidLoad];
    noOfColum = 4;
    noOfRow = 2;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    float   angle = M_PI/2;  //rotate 180°, or 1 π radians
    self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);

}
- (void) viewWillAppear:(BOOL)animated
{
    [(VLWMAppDelegate *)[UIApplication sharedApplication].delegate musicOn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(int)miNoOfColum
{
    return noOfColum;
}
+(int)miNoOfRow
{
    return noOfRow;
}

#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Main_EditGameList_SegID"]){
        [(VLWMAppDelegate *)[UIApplication sharedApplication].delegate stopMusic];
    }
    if ([[segue identifier] isEqualToString:@"Main_PlayGameList_SegID"]){
        VLWMPlayListView * playList = [segue destinationViewController];
        playList.mstrAniRes = @"pencil";
        [playList willPlayAni:YES];
    }
    CFURLRef inFileURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"chime_short" ofType:@"aac"]]);
    SystemSoundID ssID;
    AudioServicesCreateSystemSoundID(inFileURL, &ssID);
    AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,releaseSoundComplete,(__bridge void*) self);
    AudioServicesPlaySystemSound(ssID);
}
static void releaseSoundComplete (SystemSoundID  ssID, void* myself)
{
    AudioServicesRemoveSystemSoundCompletion (ssID);
    AudioServicesDisposeSystemSoundID(ssID);
}
- (IBAction)switchMusicState:(id)sender {
    [(VLWMAppDelegate *)[UIApplication sharedApplication].delegate switchMusicOnOff];
}
- (IBAction)openControl
{
            [(VLWMAppDelegate *)[UIApplication sharedApplication].delegate stopMusic];
        VLWMGameListView * gameView = [self.storyboard instantiateViewControllerWithIdentifier:@"GameListView"];
    gameView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:gameView animated:YES];
}
- (IBAction)openGame
{
//    VLWMPlayListView * playList = [segue destinationViewController];
//    playList.mstrAniRes = @"pencil";
//    [playList willPlayAni:YES];
    CFURLRef inFileURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"chime_short" ofType:@"aac"]]);
    SystemSoundID ssID;
    AudioServicesCreateSystemSoundID(inFileURL, &ssID);
    AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,releaseSoundComplete,(__bridge void*) self);
    AudioServicesPlaySystemSound(ssID);

    VLWMPlayListView * gameView = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayListView"];
    gameView.mstrAniRes = @"pencil";
    [gameView willPlayAni:YES];
    gameView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:gameView animated:YES];
    
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
