//
//  VLWMItemDataController.m
//  Where's Mummy
//
//  Created by Vu Long on 23/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMItemDataController.h"
#import "VLWMItemInfo.h"
@interface VLWMItemDataController()
-(void)initializeDefaultDataList;
@end
@implementation VLWMItemDataController
- (void)initializeDefaultDataList {
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    self.masterItemDataList  = dataList;
    VLWMItemInfo *info;
    info = [[VLWMItemInfo alloc] initWithName:@"Mami" question:@"Where is mami?" runStyle:0 shakeStyle:0];
    [self addItemWithInfo:info];
//    VLWMItemInfo *info2 = [[VLWMItemInfo alloc] initWithName:@"Dady" question:@"Where is daddy?"];
//    [self addItemWithInfo:info2];
}
- (void)setMasterItemDataList:(NSMutableArray *)newList {
    if (_masterItemDataList != newList) {
        _masterItemDataList = [newList mutableCopy];
    }
}
- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}
- (NSUInteger)countOfList {
    return [self.masterItemDataList count];
}
- (VLWMItemInfo *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterItemDataList objectAtIndex:theIndex];
}
- (void)addItemWithInfo:(VLWMItemInfo *)info {
    [self.masterItemDataList addObject:info];
}
@end
