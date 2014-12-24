//
//  Game.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * creatorId;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * gameId;
@property (nonatomic, retain) NSNumber * locationLat;
@property (nonatomic, retain) NSNumber * locationLong;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) id userIdArray;

@end
