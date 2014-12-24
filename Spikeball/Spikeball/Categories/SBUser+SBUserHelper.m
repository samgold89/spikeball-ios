//
//  SBUser+SBUserHelper.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBUser+SBUserHelper.h"
#import <CoreData+MagicalRecord.h>

@implementation SBUser (SBUserHelper)

+ (SBUser*)currentUser {
    //TODO: MAKE THIS REAL
    SBUser *user = [SBUser MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    user.userId = @1;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return user;
}

@end
