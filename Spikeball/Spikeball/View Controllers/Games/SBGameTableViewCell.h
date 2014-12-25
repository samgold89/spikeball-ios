//
//  SBGameTableViewCell.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

static CGFloat kCellHeight = 79;

@interface SBGameTableViewCell : UITableViewCell

- (void)setupCellContentWithGame:(Game*)game;

@end
