//
//  SBPlayerCollectionViewCell.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBPlayerCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBLibrary.h"

@interface SBPlayerCollectionViewCell ()

@property (nonatomic,strong) UIImageView *playerImageView;
@property (nonatomic,strong) UILabel *playerNameLabel;

@end

@implementation SBPlayerCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.playerImageView = [[UIImageView alloc] init];
        self.playerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.playerImageView.layer.masksToBounds = YES;
        self.playerImageView.layer.cornerRadius = kPlayerImageHeight/2;
        self.playerImageView.layer.borderColor = [[UIColor spikeballBlack] colorWithAlphaComponent:0.4].CGColor;
        self.playerImageView.layer.borderWidth = 0.5;
        [self addSubview:self.playerImageView];
        
        self.playerNameLabel = [[UILabel alloc] init];
        self.playerNameLabel.translatesAutoresizingMaskIntoConstraints = NO;self.playerNameLabel.textColor = [UIColor blackColor];
        self.playerNameLabel.font = [UIFont fontWithName:SBFontStandard size:14];
        [self addSubview:self.playerNameLabel];
        
        self.backgroundColor = [UIColor clearColor];//[@[[UIColor redColor],[UIColor yellowColor],[UIColor greenAccept],[UIColor purpleColor],[UIColor spikeballYellow],[UIColor spikeballBlack],[UIColor orangeColor],[UIColor brownColor]] randomElement];
        
        [self setupConstraints];
    }
    return self;
}

- (void)configureCellWithUser:(SBUser*)user {
    [self.playerImageView sd_setImageWithURL:[NSURL URLWithString:user.imageUrl]  placeholderImage:[UIImage imageNamed:@"player_placeholder_image"]];
    self.playerNameLabel.text = user.nickName ? user.nickName : user.firstName ? user.firstName : user.lastName ? user.lastName : @"JonhDoe";
}

- (void)setupConstraints {
    [NSLayoutConstraint topOfChild:self.playerImageView toTopOfParent:self withFixedMargin:kImageToEdgeBuffer];
    [NSLayoutConstraint view:self.playerImageView toFixedHeight:kPlayerImageHeight];
    [NSLayoutConstraint view:self.playerImageView widthToMultipleOfHeight:1];
    [NSLayoutConstraint centerXOfChild:self.playerImageView toCenterXOfParent:self];
    
    [NSLayoutConstraint topOfChild:self.playerNameLabel toBottomOfSibling:self.playerImageView withFixedMargin:2 inParent:self];
    [NSLayoutConstraint centerXOfChild:self.playerNameLabel toCenterXOfSibling:self.playerImageView inParent:self];
}

@end
