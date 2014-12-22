//
//  SBEmailAndNameViewController.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/21/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kTextFieldHeight = 44;

@protocol SBEmailAndNameViewControllerDelegate <NSObject>

- (void)translateViewByValue:(CGFloat)shift;
- (void)restoreViewToIdentity;
- (void)updateLocationWithName:(NSString*)name;
- (void)setPannerEnabled:(BOOL)enabled;

@end

@interface SBEmailAndNameViewController : UIViewController

@property (nonatomic,weak) id <SBEmailAndNameViewControllerDelegate>delegate;

- (void)endAllEditing;
- (void)setTopContainerHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setBottomContainerHidden:(BOOL)hidden animated:(BOOL)animated;

@end
