//
//  SBMapWithGameViewController.h
//  Spikeball
//
//  Created by Sam Goldstein on 12/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SBMapWithGameViewController : UIViewController

- (void)setMapViewZoomForGameWithLocation:(CLLocation*)location animated:(BOOL)animated;

@property (nonatomic, assign) CLLocationCoordinate2D latLongGameLocation;

@end
