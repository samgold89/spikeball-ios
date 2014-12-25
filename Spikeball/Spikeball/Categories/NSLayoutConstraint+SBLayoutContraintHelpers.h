//
//  NSLayoutConstraint+SBLayoutContraintHelpers.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/24/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSLayoutConstraint+HAWHelpers/NSLayoutConstraint+HAWHelpers.h>

@interface NSLayoutConstraint (SBLayoutContraintHelpers)

+ (NSArray*)extentOfChild:(UIView*)child toExtentOfSibling:(UIView*)sibling inParent:(UIView*)parent;

@end
