//
//  VLWMGameInfo.h
//  Where's Mummy
//
//  Created by Vu Long on 03/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLWMGameInfo : NSObject
@property (strong) NSString *GameName;
//@property (strong) NSString *GameType;//F=free; P=paid
//@property (strong) NSString *CreatedBy;//U=user; P=producer
//@property (strong) NSString  *Purchased;//Y=yes; N=no
@property BOOL *lock;//0=Lock; 1=unlock
@property NSInteger  *priceTier;//tier1,tier2,tier3,tier4,tier5
@property BOOL *isNew;//Y=yes; N=no
@property BOOL *isCompleted;//Y=yes; N=no
//- (id)initWithName:(NSString*)name createdby:(NSString*)creator type:(NSString*)type purchase:(NSString*)purchased priceTier:(NSString*)price isNew:(NSString *)new isComplete:(NSString *)complete;
- (id)initWithName:(NSString*)name lock:(BOOL)lock priceTier:(NSInteger *)price isNew:(BOOL )new isComplete:(BOOL )complete;
@end
