//
//  NSArray+GFCRandomElement.m
//  GainHybridLibrary
//
//  Created by Sam Goldstein on 3/12/14.
//  Copyright (c) 2014 Gain Fitness. All rights reserved.
//

#import "NSArray+GFCRandomElement.h"

@implementation NSArray (GFCRandomElement)

- (id)randomElement {
    if ([self count] == 0) {
        return nil;
    } else {
        return [self objectAtIndex: arc4random() % [self count]];
    }
}

- (NSArray*)shuffleArray {
    NSMutableArray *shuffledArray = [@[] mutableCopy];
    NSMutableArray *mutableSelf = [self mutableCopy];
    
    while ([mutableSelf count] > 0) {
        id element = [mutableSelf randomElement];
        [shuffledArray addObject:element];
        [mutableSelf removeObject:element];
    }
    
    return shuffledArray;
}

@end
