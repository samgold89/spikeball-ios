//
//  SBViewConstants.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/19/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBViewConstants.h"

@implementation SBViewConstants

NSString *const SBAppModelName = @"SpikeballModel_1.sqlite";

NSString *const SBFontStandardUltraLight = @"HelveticaNeue-UltraLight";
NSString *const SBFontStandardLight = @"HelveticaNeue-Light";
NSString *const SBFontStandardBold =  @"HelveticaNeue-Medium";
NSString *const SBFontStandard = @"HelveticaNeue";

NSString *const SBPushNotificationActionAcceptGame = @"ACCEPT_GAME_ACTION";
NSString *const SBPushNotificationActionRejectGame = @"REJECT_GAME_ACTION";
NSString *const SBPushNotificationCategoryNewGame = @"NEW_GAME_CATEGORY";

NSString *const SBNotificationDidRegisterForPushNotifications = @"didRegisterForPushNotifications";
NSString *const SBNotificationFailedToRegisterForPushNotifications = @"failedToRegisterForPushNotifications";
NSString *const SBNotificationDidRegisterForLocationServices = @"didRegisterForLocationServices";
NSString *const SBNotificationFailedToRegisterForLocationServices = @"failedToRegisterForLocationServices";

@end
