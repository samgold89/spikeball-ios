//
//  SBViewConstants.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/19/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBViewConstants : NSObject

FOUNDATION_EXPORT NSString *const SBAppModelName;

FOUNDATION_EXPORT NSString *const SBFontStandardUltraLight;
FOUNDATION_EXPORT NSString *const SBFontStandardLight;
FOUNDATION_EXPORT NSString *const SBFontStandardBold;
FOUNDATION_EXPORT NSString *const SBFontStandard;

FOUNDATION_EXPORT NSString *const SBPushNotificationActionAcceptGame;
FOUNDATION_EXPORT NSString *const SBPushNotificationActionRejectGame;
FOUNDATION_EXPORT NSString *const SBPushNotificationCategoryNewGame;

FOUNDATION_EXPORT NSString *const SBNotificationDidRegisterForPushNotifications;
FOUNDATION_EXPORT NSString *const SBNotificationFailedToRegisterForPushNotifications;
FOUNDATION_EXPORT NSString *const SBNotificationDidRegisterForLocationServices;
FOUNDATION_EXPORT NSString *const SBNotificationFailedToRegisterForLocationServices;

FOUNDATION_EXPORT NSString *const SBNotificationGameCellSwipeBeganWithCell;

@end
