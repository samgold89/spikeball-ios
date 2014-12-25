//
//  UIColor+SpikeballColors.m
//  Spikeball
//
//  Created by Sam Goldstein on 11/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "UIColor+SpikeballColors.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (SpikeballColors)

+ (UIColor *)colorWithWebRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [self colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
}

+ (UIColor *)spikeballYellow
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xfedd05);
        
    });
    return color;
}

+ (UIColor *)spikeballBlack
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x040113);
        
    });
    return color;
}

+ (UIColor *)greenAccept
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x0bc72e);
        
    });
    return color;
}

+ (UIColor *)redDecline
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xef0202);
        
    });
    return color;
}

+ (UIColor *)lightGrayGameCellsBackground
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xefeff4);
        
    });
    return color;
}

@end
