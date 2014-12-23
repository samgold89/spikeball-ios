//
//  SBLocationAndNotificationsViewController.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/21/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SBLocationAndNotificationsViewControllerDelegate <NSObject>

- (void)moveToFinalSummaryView;

@end

@interface SBLocationAndNotificationsViewController : UIViewController

@property (nonatomic,weak) id <SBLocationAndNotificationsViewControllerDelegate>delegate;
@property (readonly) UILabel *topNameabel;

- (void)showAllContent;

@end
