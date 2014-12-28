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

+ (NSLayoutConstraint*)centerXOfChild:(UIView*)child toCenterXOfSibling:(UIView *)sibling inParent:(UIView *)parent withMargin:(CGFloat)margin {
    return [self attrOfChild:child toSameAttrOfSibling:sibling inParent:parent attr:NSLayoutAttributeCenterX constant:margin];
}

+ (NSLayoutConstraint*)attrOfChild:(UIView*)child toSameAttrOfSibling:(UIView*)sibling inParent:(UIView*)parent attr:(NSLayoutAttribute)attr constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:child attribute:attr relatedBy:NSLayoutRelationEqual toItem:sibling attribute:attr multiplier:1.0 constant:constant];
    [parent addConstraint:constraint];
    return constraint;
}

@end
