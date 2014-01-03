//
//  VLWMItemInfo.m
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMItemInfo.h"

@implementation VLWMItemInfo
//@synthesize ItemName = _ItemName;
//@synthesize ItemQuestion= _ItemQuestion;
//@synthesize runStyle = _runStyle;
//@synthesize shakeStyle= _shakeStyle;

- (id)initWithName:(NSString*)name question:(NSString*)question runStyle:(NSInteger)run shakeStyle:(NSInteger)shake{
    if ((self = [super init])) {
        self.ItemName = name;
        self.ItemQuestion = question;
        self.runStyle = run;
        self.shakeStyle = shake;
        return self;
    }
    return nil;
}
#pragma mark NSCoding
#define kNameKey       @"Name"
#define kQuesKey      @"Ques"
#define kRunStyle @"RunStyle"
#define kShakeStyle @"ShakeStyle"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_ItemName forKey:kNameKey];
    [encoder encodeObject:_ItemQuestion forKey:kQuesKey];
    [encoder encodeInteger:_runStyle forKey:kRunStyle];
    [encoder encodeInteger:_shakeStyle forKey:kShakeStyle];
}
- (id)initWithCoder:(NSCoder *)decoder {
    NSString *nameStr = [decoder decodeObjectForKey:kNameKey];
    NSString *quesStr = [decoder decodeObjectForKey:kQuesKey];
    NSInteger run =[decoder decodeIntegerForKey:kRunStyle];
        NSInteger shake =[decoder decodeIntegerForKey:kShakeStyle];
    return [self initWithName:nameStr question:quesStr runStyle:run shakeStyle:shake];
}
@end
