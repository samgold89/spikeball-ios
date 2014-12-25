//
//  SBPlayerImageCollectionViewController.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPlayerCollectionViewCell.h"

@interface SBPlayerImageCollectionViewController : UIViewController

@property (nonatomic,strong) NSArray *playerIdArray;

- (NSArray*)allVisibleCellsOrderedByX;

@end
