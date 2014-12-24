//
//  SWTableViewCell+GameInfoSetup.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SWTableViewCell.h"
#import "Game.h"

@interface SWTableViewCell (GameInfoSetup)


- (void)setupCellContentWithGame:(Game*)game;

@end
