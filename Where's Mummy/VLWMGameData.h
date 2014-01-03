//
//  VLWMGameData.h
//  Where's Mummy
//
//  Created by Vu Long on 23/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VLWMGameInfo;
@interface VLWMGameData : NSObject
@property (nonatomic,strong) VLWMGameInfo *gameInfo;
@property (strong) NSMutableArray *itemList;
@property (strong) UIImage *dispImage;
@property (copy) NSString *docPath;
@property (copy) NSString *bgImgPath;
- (NSMutableArray *)getNextBatch:(BOOL*)shuffle;
- (id)loadItemData:(BOOL*)shuffle ;
+ (NSString *)nextItemDataPath:(NSString *) privatePath;
- (id)initWithName:(NSString*)name;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveGame;
- (void)saveGameData:(BOOL *)isLock priceTier:(NSInteger *)price isNew:(BOOL *)isNew isComplete:(BOOL *)complete;
- (BOOL)deleteDoc:(NSString *)deletePath;
- (BOOL)hasMoreItem;
@end
