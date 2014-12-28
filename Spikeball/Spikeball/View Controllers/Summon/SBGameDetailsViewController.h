//
//  SBGameDetailsViewController.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/26/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SBGameDetailsViewControllerDelegate <NSObject>

- (void)dismissViewControllerDown;

@end

@interface SBGameDetailsViewController : UIViewController

@property (nonatomic,weak) id <SBGameDetailsViewControllerDelegate>delegate;
- (void)setLayoutConstants;

@end
