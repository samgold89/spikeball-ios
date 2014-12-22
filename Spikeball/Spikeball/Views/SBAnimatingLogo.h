//
//  SBAnimatingLogo.h
//  Spikeball
//
//  Created by Sam Goldstein on 11/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAnimatingLogo : UIView

- (id)initWithFrame:(CGRect)frame andLogoColor:(UIColor*)color;
- (void)startAllAnimations;
- (void)stopAllAnimations;

@end
