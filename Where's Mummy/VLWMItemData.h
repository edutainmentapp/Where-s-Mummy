//
//  VLWMItemData.h
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@class VLWMItemInfo;
NSString *_dataPath;
@interface VLWMItemData : NSObject
@property (nonatomic,strong) VLWMItemInfo *itemInfo;
@property (nonatomic,strong) UIImage *dispImage;
//@property (strong) UIImage *fullImage;
- (id)initWithTitle:(NSString*)name question:(NSString *)question dispImage:(UIImage *)dispImage fullImage:(UIImage *)fullImage;
- (void)createBlankItemInfo:(NSString *)strName question:(NSString *)strQues;
@property (copy) NSString *docPath;
@property (copy) NSString *privatePath;
- (NSString *)getQuesSoundID;
- (NSString *)getAnswSoundID;
- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)deleteData;
- (void)saveImages;
@end
