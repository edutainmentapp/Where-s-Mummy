//
//  VLWMItemInfo.h
//  Where's Mummy
//
//  Created by Vu Long on 22/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLWMItemInfo : NSObject
@property (strong) NSString *ItemName;
@property (strong) NSString *ItemQuestion;
@property NSInteger *runStyle;
@property NSInteger *shakeStyle;
- (id)initWithName:(NSString*)name question:(NSString*)question runStyle:(NSInteger)run shakeStyle:(NSInteger)shake;
@end
