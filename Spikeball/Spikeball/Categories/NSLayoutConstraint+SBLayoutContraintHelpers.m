//
//  NSLayoutConstraint+SBLayoutContraintHelpers.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/24/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "NSLayoutConstraint+SBLayoutContraintHelpers.h"

@implementation NSLayoutConstraint (SBLayoutContraintHelpers)

+ (NSArray*)extentOfChild:(UIView*)child toExtentOfSibling:(UIView*)sibling inParent:(UIView*)parent {
    NSMutableArray *constraints = [@[[NSLayoutConstraint leftOfChild:child toLeftOfSibling:sibling withFixedMargin:0 inParent:parent]] mutableCopy];
    [constraints addObject:[NSLayoutConstraint rightOfChild:child toRightOfSibling:sibling withFixedMargin:0 inParent:parent]];
    [constraints addObject:[NSLayoutConstraint bottomOfChild:child toBottomOfSibling:sibling withFixedMargin:0 inParent:parent]];
    [constraints addObject:[NSLayoutConstraint topOfChild:child toTopOfSibling:sibling withFixedMargin:0 inParent:parent]];
    return constraints;
}

@end
