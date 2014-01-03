//
//  VLWMAppInfo.m
//  Where's Mummy
//
//  Created by Vu Long on 14/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMAppInfo.h"

@implementation VLWMAppInfo
- (id)initWithName:(NSString*)name status:(NSInteger)iStat currGameID:(NSInteger) iCurrGameID gameLoaded:(BOOL) isLoaded
{
    if ((self = [super init])) {
        self.appStatus = iStat;
        self.currGameID = iCurrGameID;
        self.gameLoaded = isLoaded;
        return self;
    }
    return nil;
}
#define kStatus      @"KStatus"
#define kGameID      @"KGameID"
#define kGameLoaded  @"KGameLoaded"
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:_appStatus forKey:kStatus];
    [encoder encodeInteger:_currGameID forKey:kGameID];
    [encoder encodeBool:_gameLoaded forKey:kGameLoaded];
}
- (id)initWithCoder:(NSCoder *)decoder {
    NSInteger appStatus = [decoder decodeIntegerForKey:kStatus];
    NSInteger iCurrGameID = [decoder decodeIntegerForKey:kGameID];
    BOOL gameLoaded = [decoder decodeBoolForKey:kGameLoaded];
    return [self initWithName:nil status:appStatus currGameID:iCurrGameID gameLoaded:gameLoaded];
}
@end
