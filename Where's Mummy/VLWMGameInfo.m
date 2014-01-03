//
//  VLWMGameInfo.m
//  Where's Mummy
//
//  Created by Vu Long on 03/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMGameInfo.h"

@implementation VLWMGameInfo
//- (id)initWithName:(NSString*)name createdby:(NSString *)creator type:(NSString *)type purchase:(NSString *)purchased priceTier:(NSString *)price isNew:(NSString *)new isComplete:(NSString *)complete
//{
//    if ((self = [super init])) {
//        self.GameName = name;
////        self.CreatedBy = creator;
////        self.GameType = type;
////        self.Purchased = purchased;
//        self.priceTier = price;
//        self.isNew = new;
//        self.isCompleted = complete;
//        return self;
//    }
//    return nil;
//}
- (id)initWithName:(NSString*)name lock:(BOOL)lock priceTier:(NSInteger *)price isNew:(BOOL )new isComplete:(BOOL )complete
{
    if ((self = [super init])) {
        self.GameName = name;
        self.lock = lock;
        self.priceTier = price;
        self.isNew = new;
        self.isCompleted = complete;
        return self;
    }
    return nil;
}
#pragma mark NSCoding
#define kGameName       @"Name"
#define kLock       @"Lock"
#define kPrice      @"Price"
#define kNew      @"KNew"
#define kComplete      @"KComplete"
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_GameName forKey:kGameName];
    if(_lock!=nil)
        [encoder encodeBool:_lock forKey:kLock];
    if(_priceTier!=nil)
        [encoder encodeInteger:_priceTier forKey:kPrice];
    if(_isNew!=nil)
        [encoder encodeBool:_isNew forKey:kNew];
    if(_isCompleted!=nil)
        [encoder encodeBool:_isCompleted forKey:kComplete];
}
- (id)initWithCoder:(NSCoder *)decoder {
    NSString *nameStr = [decoder decodeObjectForKey:kGameName];
    BOOL lock = [decoder decodeBoolForKey:kLock];
    NSInteger price = [decoder decodeIntegerForKey:kPrice];
    BOOL isNew = [decoder decodeBoolForKey:kNew];
    BOOL isCompleted = [decoder decodeBoolForKey:kComplete];
    
    return [self initWithName:nameStr lock:lock priceTier:price isNew:isNew isComplete:isCompleted];
//    return [self initWithName:nameStr createdby:creatorStr type:typeStr purchase:puchased priceTier:price isNew:isNew isComplete:isCompleted];
}
@end
