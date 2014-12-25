//
//  SBPlayerCollectionViewCell.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBUser+SBUserHelper.h"

static NSInteger kPlayerImageHeight = 52;
static NSInteger kPlayerCellHeight = 80;
static NSInteger kImageToEdgeBuffer = 7;

@interface SBPlayerCollectionViewCell : UICollectionViewCell

- (void)configureCellWithUser:(SBUser*)user;

@end
