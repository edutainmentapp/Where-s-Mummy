//
//  VLWMItemDataController.h
//  Where's Mummy
//
//  Created by Vu Long on 23/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VLWMItemInfo;
@interface VLWMItemDataController : NSObject
@property (nonatomic, copy) NSMutableArray *masterItemDataList;
- (NSUInteger)countOfList;
- (VLWMItemInfo *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addItemInfoWithInfo:(VLWMItemInfo *)info;
@end
