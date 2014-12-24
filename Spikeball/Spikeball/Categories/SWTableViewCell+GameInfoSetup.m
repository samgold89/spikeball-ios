//
//  SWTableViewCell+GameInfoSetup.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SWTableViewCell+GameInfoSetup.h"
#import "SBUser+SBUserHelper.h"
#import "SBLibrary.h"

@implementation SWTableViewCell (GameInfoSetup)

- (void)setupCellContentWithGame:(Game*)game {
    self.gameNamesLabel.text = @"Sarah, John & Mike";
    self.startsWhenLabel.text = @"Starts in 10 min!";
    self.startsWhenLabel.textColor = [UIColor greenAccept];
    self.distanceAddressLabel.text = @"10 mi away - 536 Waller St";
    self.creatorImageView.image = arc4random_uniform(2) == 1 ? [UIImage imageNamed:@"_0000_Layer-1"] : [UIImage imageNamed:@"_0001_Layer-2"];
    NSArray *gameUserIdArray = [NSKeyedUnarchiver unarchiveObjectWithData:game.userIdArray];
    SBUser *user = [SBUser currentUser];
    self.responseStatusVerticalBar.backgroundColor = [gameUserIdArray containsObject:user.userId] ? [UIColor greenAccept] : [UIColor redDecline];
}

@end
