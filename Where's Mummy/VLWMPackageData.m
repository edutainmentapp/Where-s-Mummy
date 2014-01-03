//
//  VLWMPackageData.m
//  Where's Mummy
//
//  Created by Vu Long on 27/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMPackageData.h"
#import "VLWMGameData.h"
#import "VLWMAppInfo.h"
#import "VLWMAppDelegate.h"
#define kAppDataKey @"AppInfo"
#define kAppDataFile @"AppInfo.plist"
@implementation VLWMPackageData
@synthesize docPath = _docPath;
+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}
+ (NSMutableArray *)loadGameData {
    
    // Get private docs dir
    NSString *documentsDirectory = [VLWMPackageData getPrivateDocsDir];
    NSLog(@"Loading game data from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading game data from directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Create VLWMGameData for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"GameData" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            VLWMGameData *doc = [[VLWMGameData alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    
    return retval;
}
+ (NSString *)nextGameDataPath {
    
    // Get private docs dir
    NSString *documentsDirectory = [VLWMPackageData getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"GameData" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.GameData", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}
+(BOOL)gameLoaded
{
    VLWMAppInfo * appInfo = [VLWMPackageData appInfo];
    if (appInfo==nil)
        return NO;
    else
        return [appInfo gameLoaded];
}
+ (NSInteger) appStatus
{
    VLWMAppInfo * appInfo = [VLWMPackageData appInfo];
    if (appInfo==nil)
    {
        [self setAppStatus:0];
        return 0;
    }
    NSInteger appStatus = [appInfo appStatus];
    return appStatus;
}
+(void)setAppStatus:(NSInteger)intSta
{
    VLWMAppInfo * appInfo = [self appInfo];
    if (appInfo == nil) {
        appInfo = [[VLWMAppInfo alloc] initWithName:nil status:intSta currGameID:0 gameLoaded:NO];
    }
    [VLWMPackageData saveAppInfo:appInfo];
}
+(void)gameIsLoaded
{
    VLWMAppInfo * appInfo = [self appInfo];
    if (appInfo == nil) {
        appInfo = [[VLWMAppInfo alloc] initWithName:nil status:0 currGameID:0 gameLoaded:YES];
    }
    appInfo.gameLoaded = YES;
    [VLWMPackageData saveAppInfo:appInfo];
}
//+ (NSInteger) mNextGameID;
- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [VLWMPackageData nextGameDataPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}
+ (VLWMAppInfo *)appInfo {
    NSString *dataPath = [[self getPrivateDocsDir] stringByAppendingPathComponent:kAppDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    VLWMAppInfo * appInfo = [unarchiver decodeObjectForKey:kAppDataKey];
    [unarchiver finishDecoding];
    return appInfo;
}
+ (void)saveAppInfo:(VLWMAppInfo *)appInfo {
    
    if (appInfo == nil) return;
    
    NSString *dataPath = [[self getPrivateDocsDir] stringByAppendingPathComponent:kAppDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:appInfo forKey:kAppDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}
@end
