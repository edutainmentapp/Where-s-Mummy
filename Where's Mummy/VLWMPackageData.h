//
//  VLWMPackageData.h
//  Where's Mummy
//
//  Created by Vu Long on 27/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLWMAppInfo.h"
@interface VLWMPackageData : NSObject
@property (copy) NSString *docPath;
+ (NSMutableArray *)loadGameData;
+ (NSString *)nextGameDataPath;
+ (NSInteger) appStatus;
+ (BOOL)gameLoaded;
//+ (NSInteger) mNextGameID;
+ (VLWMAppInfo *)appInfo;
+ (void)gameIsLoaded;
//- (void)saveData;
@end
