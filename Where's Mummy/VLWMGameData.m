//
//  VLWMGameData.m
//  Where's Mummy
//
//  Created by Vu Long on 23/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMGameData.h"
#import "VLWMItemData.h"
#import "VLWMPackageData.h"
#import "VLWMGameInfo.h"
#import "NSMutableArray+Shuffle.h"
#define kDataKey @"Game"
#define kDataFile @"game.plist"
#define kDispImageFile @"dispImage.png"
#define kBgImageFile @"bgImage.png"
@implementation VLWMGameData
{
    NSInteger miCurBatch;
}
//@synthesize itemList = _itemList;
@synthesize docPath = _docPath;
NSInteger miBatchSize = 8;

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}
- (id)initWithName:(NSString*)name
{
    if ((self = [super init])) {
//        self.gameInfo = [[VLWMGameInfo alloc] initWithName:name createdby:author type:@"F" purchase:@"N" priceTier:@"0" isNew:@"Y" isComplete:@"N"];
        self.gameInfo = [[VLWMGameInfo alloc] initWithName:name lock:0 priceTier:0 isNew:YES isComplete:NO];

        self.dispImage = [UIImage imageNamed:@"g_demo_1.png"] ;
    }
    return self;
}
//- (void)addObject:(VLWMItemData *)itemData
//{
//    [_itemList addObject:itemData];
//}
+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}
-(BOOL)hasMoreItem
{
    return (miBatchSize*miCurBatch<=_itemList.count?YES:NO);
}
- (NSMutableArray *)getNextBatch:(BOOL*)shuffle
{
    miCurBatch ++;
    NSMutableArray * batch = [NSMutableArray arrayWithCapacity:miBatchSize];
    int iStartIndex = miBatchSize*miCurBatch-miBatchSize;
    for (int x = iStartIndex;x < (miBatchSize*miCurBatch<_itemList.count?miBatchSize*miCurBatch:_itemList.count); x++)
    {
        [batch addObject:[_itemList objectAtIndex:x]];
    }
    if(shuffle)
        [batch shuffleArray];
    return batch;
}
- (id)loadItemData:(BOOL*)shuffle {
    if(self.gameInfo==nil)
//        self.gameInfo = [[VLWMGameInfo alloc] initWithName:@"Game Name" createdby:@"P" type:@"F" purchase:@"N" priceTier:@"tier1" isNew:@"Y" isComplete:@"N"];
        self.gameInfo = [[VLWMGameInfo alloc] initWithName:@"Game Name" lock:0 priceTier:0 isNew:YES isComplete:NO];
    // Get private docs dir
    NSString *documentsDirectory = _docPath;
    NSLog(@"Loading item data from %@", documentsDirectory);
    
    _bgImgPath = [_docPath stringByAppendingPathComponent:kBgImageFile];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    // Create VLWMItemData for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"ItemData" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            VLWMItemData *doc = [[VLWMItemData alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    if(shuffle)
        [retval shuffleArray];

    self.itemList = retval;
    miCurBatch = 0;
    return retval;
}

+ (NSString *)nextItemDataPath:(NSString *) privatePath {
    NSString *documentsDirectory = privatePath;
    // Get private docs dir
    if(privatePath==nil)
    {
        documentsDirectory = [VLWMGameData getPrivateDocsDir];
    }
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
        if ([file.pathExtension compare:@"ItemData" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.ItemData", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}
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
- (void)saveGame {
    if (_dispImage == nil) return;
    [self createDataPath];
    
    NSString *dispImagePath = [_docPath stringByAppendingPathComponent:kDispImageFile];
    NSData *dispImageData = UIImagePNGRepresentation(_dispImage);
    [dispImageData writeToFile:dispImagePath atomically:YES];
    
    self.dispImage = nil;
}
- (BOOL)deleteDoc:(NSString *)deletePath {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:deletePath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    return success;
}
- (UIImage *)dispImage {
    if (_dispImage != nil) return _dispImage;
    
    NSString *dispImagePath = [_docPath stringByAppendingPathComponent:kDispImageFile];
    return [UIImage imageWithContentsOfFile:dispImagePath];
}
- (VLWMGameInfo *)gameInfo {
    if (_gameInfo != nil) return _gameInfo;
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _gameInfo = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    return _gameInfo;
}
- (void)saveGameData:(BOOL *)isLock priceTier:(NSInteger *)price isNew:(BOOL *)isNew isComplete:(BOOL *)complete {
    
    if (_gameInfo == nil) return;
    else
    {
        _gameInfo.lock = isLock;
        _gameInfo.priceTier = price;
        _gameInfo.isNew = isNew;
        _gameInfo.isCompleted = complete;
    }
    
    [self createDataPath];
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_gameInfo forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

@end
