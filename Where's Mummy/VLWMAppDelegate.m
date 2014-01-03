//
//  VLWMAppDelegate.m
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMAppDelegate.h"
#import "SSZipArchive.h"
#import "VLWMPackageData.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
@implementation VLWMAppDelegate
static BOOL mbMusicIsOn;
static BOOL mbMusicIsPlaying;
static NSMutableArray * mainSongs;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"App Status: %d",[VLWMPackageData appStatus]);
    if(![VLWMPackageData gameLoaded])
        [self unpackDefaultGame];
    // Override point for customization after application launch.
    NSString * path = [[NSBundle mainBundle]pathForResource:@"gs01" ofType:@"aac"];
    NSString * path2 = [[NSBundle mainBundle]pathForResource:@"gs02" ofType:@"aac"];
    mainSongs = [NSMutableArray arrayWithObjects:path,path2, nil];
    mbMusicIsPlaying = NO;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)unpackDefaultGame
{
    NSString *privateDir = [self getPrivateDocsDir];
    //    //If your zip is in document directory than use this code
    //    NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:@"mediadata.zip"];
    //else if zip file is in bundle than use this code
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"DefaultPackage" ofType:@"zip"];
    
    if( [SSZipArchive unzipFileAtPath:zipPath toDestination:privateDir] != NO )
    {
        [VLWMPackageData gameIsLoaded];
        NSLog(@"Default games loaded to this iPhone");
    }else{
        NSLog(@"Unable to unzip game package");
    }
}
- (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}
- (void)playMusic
{
    if(mbMusicIsOn&&!mbMusicIsPlaying)
    {
    NSUInteger randomIndex = arc4random() % [mainSongs count];
    NSURL *url = [NSURL fileURLWithPath:[mainSongs objectAtIndex:randomIndex]];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    mbMusicIsPlaying = YES;
    }
}
-(void)stopMusic
{
    [_audioPlayer stop];
    _audioPlayer = nil;
}
-(BOOL)musicIsPlaying
{
    return mbMusicIsPlaying;
}
-(BOOL)musicIsOn
{
    return mbMusicIsOn;
}
-(void)switchMusicOnOff
{
    if(mbMusicIsOn)
        [self musicOff];
    else
        [self musicOn];
}
-(void)musicOn
{
    mbMusicIsOn = YES;
    [self playMusic];
    
}
-(void)musicOff
{
    mbMusicIsOn = NO;
    mbMusicIsPlaying = NO;
    [self stopMusic];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    mbMusicIsPlaying = NO;
    [self playMusic];
}
- (BOOL) fileExists:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}
//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    return UIInterfaceOrientationMaskAll;
//}
@end
