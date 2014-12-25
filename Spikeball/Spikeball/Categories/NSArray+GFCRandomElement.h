//
//  NSArray+GFCRandomElement.h
//  GainHybridLibrary
//
//  Created by Sam Goldstein on 3/12/14.
//  Copyright (c) 2014 Gain Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GFCRandomElement)

- (id)randomElement;
- (NSArray*)shuffleArray;

@end
