//
//  SBGameTableViewCell.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

static CGFloat kCellHeight = 80;
static CGFloat kCellSelectedHeight = 286;

typedef enum {
    SBCellSlieStateOpened,
    SBCellSlieStateClosed
} SBCellSlideState;

@class SBGameTableViewCell;
@protocol SBGameTableViewCellDelegate <NSObject>

- (void)cellTouchedShowGameForCell:(SBGameTableViewCell*)cell;
- (void)updateCell:(SBGameTableViewCell*)cell;

@end

@interface SBGameTableViewCell : UITableViewCell

@property (nonatomic, weak) id <SBGameTableViewCellDelegate>delegate;
@property (nonatomic, strong) Game *game;
@property (nonatomic, assign) SBCellSlideState cellSlideState;

- (void)setupCellContentWithGame:(Game*)game setOtherCellIsExpanded:(BOOL)otherCellIsEpanded;
- (void)setCellExpandedModeAnimated:(BOOL)animated;
- (void)collapseCellFromExpandedAnimated:(BOOL)animated;

@end
