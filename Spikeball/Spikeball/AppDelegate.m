//
//  AppDelegate.m
//  Spikeball
//
//  Created by Sam Goldstein on 11/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "AppDelegate.h"
#import "SBProductSummaryIntroScreenViewController.h"
#import "SBLibrary.h"
#import <CoreData+MagicalRecord.h>
#import "Game.h"
#import "SBUser+SBUserHelper.h"

//Tab Bar View Controllers
#import "SBGamesViewController.h"
#import "SBFriendsViewController.h"
#import "SBSummonViewController.h"
#import "SBAccountViewController.h"

@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) SBProductSummaryIntroScreenViewController *prodSum;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL backgroundedAppWhileMonitoringLocation;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:SBAppModelName];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self BULLSHITERASEME];
    BOOL userIsLoggedIn = YES;
    if (userIsLoggedIn) {
        [self setupRootViewControllersFromLogin:NO];
    } else {
        [self setupLoginFlow];
    }
    
    if ([CLLocationManager authorizationStatus] < kCLAuthorizationStatusAuthorizedAlways) { //no permission yet
        
    } else { //there exists permission, so grab their location or something
        
    }
    
    return YES;
}

- (void)BULLSHITERASEME{
    [Game MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [SBUser MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];

    Game *game1 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game1.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@1,@2,@3]];
    game1.locationLat = [NSNumber numberWithFloat:37.759889];
    game1.locationLong = [NSNumber numberWithFloat:-122.427018];
    game1.address = @"Mission Dolores Park";

    Game *game2 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game2.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@3,@4,@5]];
    game2.locationLat = [NSNumber numberWithFloat:37.766867];
    game2.locationLong = [NSNumber numberWithFloat:-122.442688];
    game2.address = @"Buena Vista Park";

    Game *game3 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game3.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@2,@4,@6]];
    game3.locationLat = [NSNumber numberWithFloat:37.772447];
    game3.locationLong = [NSNumber numberWithFloat:-122.446867];
    game3.address = @"San Francisco Bicycle Route 30";

    Game *game4 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game4.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@1,@2,@3,@5,@6]];
    game4.locationLat = [NSNumber numberWithFloat:35.099008];
    game4.locationLong = [NSNumber numberWithFloat:-89.853844];
    game4.address = @"6243 Poplar Pike";

    Game *game5 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game5.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@5,@6,@1]];
    game5.locationLat = [NSNumber numberWithFloat:35.072780];
    game5.locationLong = [NSNumber numberWithFloat:-89.808768];
    game5.address = @"Hacks Cross Road Park";

    Game *game6 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game6.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@1,@2,@4]];
    game6.locationLat = [NSNumber numberWithFloat:35.116250];
    game6.locationLong = [NSNumber numberWithFloat:-89.836239];
    game6.address = @"Poplar Estates Parkway";

    Game *game7 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game7.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@1,@2,@3,@4,@5,@6]];
    game7.locationLat = [NSNumber numberWithFloat:35.114395];
    game7.locationLong = [NSNumber numberWithFloat:-89.871687];
    game7.address = @"5668 Poplar Ave";

    Game *game8 = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game8.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:@[@1,@2,@4,@5,@6]];
    game8.locationLat = [NSNumber numberWithFloat:37.769556];
    game8.locationLong = [NSNumber numberWithFloat:-122.432676];
    game8.address = @"Duboce Park";
    
    SBUser *user1 = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user1.userId = @1;
    user1.nickName = @"NICKname";
    user1.imageUrl = @"https://s3.amazonaws.com/hybrid-users/images%2F426007231-C1DcHmHT0t-0a3uVm2DyR-profileImage%2FprofileImage.jpeg";
    
    SBUser *user2 = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user2.userId = @2;
    user2.firstName = @"First";
    user2.imageUrl = @"https://s3.amazonaws.com/hybrid-users/images%2F1404858470744-3548.1661674566567%2Ftrainer_sam.png";
    
    SBUser *user3 = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user3.userId = @3;
    user3.lastName = @"Lastly";
    user3.imageUrl = @"https://s3.amazonaws.com/hybrid-users/images%2F434670589-gZPIfiLXqr-m0GazxlDoW-profileImage%2FprofileImage.jpeg";
    
    SBUser *user4 = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user4.userId = @4;
    user4.nickName = @"Sleepy";
    user4.imageUrl = @"https://s3.amazonaws.com/hybrid-users/images%2F434328894-BUNnS3bkMl-3btA1mCp3P-profileImage%2FprofileImage.jpeg";
    
    SBUser *user5 = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user5.userId = @5;
    user5.nickName = @"Sammy G";
    user5.imageUrl = @"https://s3.amazonaws.com/hybrid-users/images/Chuck.png";
    
    SBUser *user6 = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user6.userId = @6;
    user6.nickName = @"Karenski";
    user6.imageUrl = @"https://s3.amazonaws.com/hybrid-users/images%2F1412008313175-9743.80403989926%2F1bce718.jpg";

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)setupLoginFlow {
    self.prodSum = [[SBProductSummaryIntroScreenViewController alloc] init];
    self.window.rootViewController = self.prodSum;
}

- (void)setupRootViewControllersFromLogin:(BOOL)fromLogin {
    SBSummonViewController *summonVc = [[SBSummonViewController alloc] init];
    summonVc.title = @"Summon";
    summonVc.tabBarItem.image = [UIImage imageNamed:@"summon_tab_bar"];
//    summonVc.tabBarItem.selectedImage = [UIImage imageNamed:@"summon_tab_bar_selected"];
    UINavigationController *summonNav = [[UINavigationController alloc] initWithRootViewController:summonVc];
    
    SBGamesViewController *gamesVc = [[SBGamesViewController alloc] init];
    gamesVc.title = @"Games";
    gamesVc.tabBarItem.image = [UIImage imageNamed:@"games_tab_bar"];
//    gamesVc.tabBarItem.selectedImage = [UIImage imageNamed:@"games_tab_bar_selected"];
    UINavigationController *gamesNav = [[UINavigationController alloc] initWithRootViewController:gamesVc];
    
    SBFriendsViewController *friendsVc = [[SBFriendsViewController alloc] init];
    friendsVc.title = @"Friends";
    friendsVc.tabBarItem.image = [UIImage imageNamed:@"friends_tab_bar"];
//    friendsVc.tabBarItem.selectedImage = [UIImage imageNamed:@"friends_tab_bar_selected"];
    UINavigationController *friendsNav = [[UINavigationController alloc] initWithRootViewController:friendsVc];
    
    SBAccountViewController *accountVc = [[SBAccountViewController alloc] init];
    accountVc.title = @"Account";
    accountVc.tabBarItem.image = [UIImage imageNamed:@"account_tab_bar"];
//    accountVc.tabBarItem.selectedImage = [UIImage imageNamed:@"summon_tab_bar_selected"];
    UINavigationController *accountNav = [[UINavigationController alloc] initWithRootViewController:accountVc];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[summonNav,gamesNav,friendsNav,accountNav];
    self.tabBarController.tabBar.tintColor = [UIColor spikeballYellow];
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    
    UIView *windowSnapshot;
    if (fromLogin) {
        windowSnapshot = [self.window snapshotViewAfterScreenUpdates:YES];
    }
    self.window.rootViewController = self.tabBarController;
    if (fromLogin) {
        windowSnapshot.frame = self.window.bounds;
        [self.window addSubview:windowSnapshot];
        self.tabBarController.view.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [UIView animateWithDuration:0.9
                              delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            windowSnapshot.center = CGPointMake(windowSnapshot.center.x, windowSnapshot.center.y+self.window.frame.size.height+50);
            self.tabBarController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [windowSnapshot removeFromSuperview];
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.locationManager stopUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark Push Notifications

-(void)registerForPushNotifications {
    UIMutableUserNotificationAction *acceptGameAction = [[UIMutableUserNotificationAction alloc] init];
    acceptGameAction.identifier = SBPushNotificationActionAcceptGame;
    acceptGameAction.title = @"Rage";
    acceptGameAction.destructive = NO;
    acceptGameAction.authenticationRequired = NO;
    acceptGameAction.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationAction *rejectGameAction = [[UIMutableUserNotificationAction alloc] init];
    rejectGameAction.identifier = SBPushNotificationActionRejectGame;
    rejectGameAction.title = @"Next Time";
    rejectGameAction.destructive = NO;
    rejectGameAction.authenticationRequired = NO;
    rejectGameAction.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationCategory *newGameCategory = [[UIMutableUserNotificationCategory alloc] init];
    newGameCategory.identifier = SBPushNotificationCategoryNewGame;
    [newGameCategory setActions:@[acceptGameAction,rejectGameAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObjects:newGameCategory, nil];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:SBPushNotificationActionAcceptGame]) {
        
    } else if ([identifier isEqualToString:SBPushNotificationActionRejectGame]) {
        
    }
    
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@",userInfo);
    
    if (userInfo[@"aps"][@"badge"]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[userInfo[@"aps"][@"badge"] integerValue]];
    }
    
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Registered for push notifications");
    [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationDidRegisterForPushNotifications object:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register remote :: %@",error.localizedDescription);
    [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationFailedToRegisterForPushNotifications object:nil];
}

#pragma mark Location Request

- (void)requestLocationAccess {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"didChange location :: %i",status);
    if ([CLLocationManager authorizationStatus] >= kCLAuthorizationStatusAuthorizedAlways) { //got permission
        [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationDidRegisterForLocationServices object:nil];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didfail get location");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationUserLocationUpdated object:[locations firstObject]];
}

- (CLLocation*)lastUserLocation {
    return self.locationManager.location;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SammyG.Spikeball" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Spikeball" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Spikeball.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
