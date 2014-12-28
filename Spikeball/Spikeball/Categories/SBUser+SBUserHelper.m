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
    return [SBUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(%K=%@)",@"userId",@1]];
}

@end
