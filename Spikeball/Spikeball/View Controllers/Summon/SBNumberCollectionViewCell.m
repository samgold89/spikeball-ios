//
//  SBNumberCollectionViewCell.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/26/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBNumberCollectionViewCell.h"
#import "SBLibrary.h"
@interface SBNumberCollectionViewCell ()

@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation SBNumberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.numberLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.numberLabel];
        
        [NSLayoutConstraint centerOfChild:self.numberLabel toCenterOfParent:self.contentView];
    }
    
    return self;
}

- (void)setDisplayNumber:(NSNumber *)displayNumber {
    _displayNumber = displayNumber;
    NSString *numberString = [displayNumber stringValue];
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:numberString];
    UIFont *bigFont = [UIFont fontWithName:SBFontStandard size:24];
    if ([numberString containsString:@"."]) { //1.5 or 2.8 or something
        UIFont *smallFont = [UIFont fontWithName:SBFontStandard size:16];
        [attString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, [numberString rangeOfString:@"."].location)];
        [attString addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange([numberString rangeOfString:@"."].location,numberString.length-[numberString rangeOfString:@"."].location)];
    } else {
        [attString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, numberString.length)];
    }
    
    self.numberLabel.attributedText = attString;
}

@end