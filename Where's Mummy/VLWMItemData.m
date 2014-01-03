//
//  VLWMItemData.m
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMItemData.h"
#import "VLWMItemInfo.h"
#import "VLWMGameData.h"
#define kDataKey @"Data"
#define kDataFile @"data.plist"
#define kDispImageFile @"dispImage.png"
#define kQuestionFile @"quessound.caf"
#define kAnswerFile @"answsound.caf"
@implementation VLWMItemData
@synthesize dispImage = _dispImage;
@synthesize docPath = _docPath;
- (id)initWithTitle:(NSString*)name question:(NSString *)question dispImage:(UIImage *)dispImage fullImage:(UIImage *)fullImage
{
    if ((self = [super init])) {
        self.itemInfo = [[VLWMItemInfo alloc] initWithName:name question:question runStyle:0 shakeStyle:0];

        self.dispImage = dispImage;
    }
    return self;
}
-(void)dealloc
{
_docPath = nil;
}
- (id)init {
return self;
}
- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}
- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [VLWMGameData nextItemDataPath:self.privatePath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}
- (void)createBlankItemInfo:(NSString *)strName question:(NSString *)strQues
{
    _itemInfo = [[VLWMItemInfo alloc] initWithName:strName question:strQues runStyle:0 shakeStyle:0];
}
- (VLWMItemInfo *)itemInfo {
    if (_itemInfo != nil) return _itemInfo;
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _itemInfo = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    return _itemInfo;
}
- (void)saveData {
    
    if (_itemInfo == nil) return;
    
    [self createDataPath];
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_itemInfo forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}
- (void)deleteDoc {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}
- (UIImage *)dispImage {
    if (_dispImage != nil) return _dispImage;
    
    NSString *dispImagePath = [_docPath stringByAppendingPathComponent:kDispImageFile];
    return [UIImage imageWithContentsOfFile:dispImagePath];
    
}
- (void)saveImages{
    if (_dispImage == nil) return;
    [self createDataPath];
    
    NSString *dispImagePath = [_docPath stringByAppendingPathComponent:kDispImageFile];
//    NSData *dispImageData = UIImagePNGRepresentation(_dispImage);
    NSData *dispImageData = [NSData dataWithData:UIImagePNGRepresentation(_dispImage)];
    [dispImageData writeToFile:dispImagePath atomically:YES];
    self.dispImage = nil;
}
- (NSString *)getQuesSoundID{
//    SystemSoundID quesSound;
    NSString *soundQuesPath = [_docPath stringByAppendingPathComponent:kQuestionFile];
    return soundQuesPath;
//    NSLog(@"sound path: %@",soundQuesPath);
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundQuesPath],&quesSound);
//    AudioServicesAddSystemSoundCompletion (quesSound, NULL, NULL,
//                                           MyAudioServicesSystemSoundCompletionProc,
//                                           (__bridge void *)(self));
//    return quesSound;
}
- (NSString *)getAnswSoundID{
//    SystemSoundID soundID;
    NSString *soundAnswPath = [_docPath stringByAppendingPathComponent:kAnswerFile];
    return soundAnswPath;
    //    NSLog(@"sound path: %@",soundQuesPath);
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundQuesPath],&soundID);
//    AudioServicesAddSystemSoundCompletion (soundID, NULL, NULL,
//                                           MyAudioServicesSystemSoundCompletionProc,
//                                           (__bridge void *)(self));
//    return soundID;
}

@end
