//
//  NSMutableArray+Shuffle.m
//  Where's Mummy
//
//  Created by Vu Long on 03/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)
- (void)shuffleArray
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
