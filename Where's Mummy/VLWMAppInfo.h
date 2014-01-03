//
//  VLWMAppInfo.h
//  Where's Mummy
//
//  Created by Vu Long on 14/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLWMAppInfo : NSObject
@property NSInteger appStatus;//0-not paid, 1-paid package 1, 2-paid package 2
@property NSInteger currGameID;
@property BOOL  gameLoaded;
- (id)initWithName:(NSString*)name status:(NSInteger)iStat currGameID:(NSInteger) iCurrGameID gameLoaded:(BOOL) isLoaded;
@end
