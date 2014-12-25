//
//  SBMapWithGameViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBMapWithGameViewController.h"
#import "AppDelegate.h"
#import "SBLibrary.h"

@interface SBMapWithGameViewController () <MKMapViewDelegate>

@property (nonatomic,assign) BOOL foundUserOnce;
@property (nonatomic,strong) MKMapView *mapView;

@end

@implementation SBMapWithGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Game Time";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate requestLocationAccess];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView.userLocation setTitle:@"You are here!"];
    [self.view addSubview:self.mapView];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [self setupConstraints];
}

- (void)setMapViewZoomForGameWithLocation:(CLLocation*)location animated:(BOOL)animated {
    // FIND REGION
    CLLocationCoordinate2D upperCoordinates = CLLocationCoordinate2DMake(location.coordinate.latitude > self.latLongGameLocation.latitude ? location.coordinate.latitude : self.latLongGameLocation.latitude, location.coordinate.longitude > self.latLongGameLocation.longitude ? location.coordinate.longitude : self.latLongGameLocation.longitude);
    CLLocationCoordinate2D lowerCoordinates = CLLocationCoordinate2DMake(location.coordinate.latitude < self.latLongGameLocation.latitude ? location.coordinate.latitude : self.latLongGameLocation.latitude, location.coordinate.longitude < self.latLongGameLocation.longitude ? location.coordinate.longitude : self.latLongGameLocation.longitude);
    
    CGFloat regionLatLongBuffer = .005;
    MKCoordinateSpan locationSpan;
    locationSpan.latitudeDelta = upperCoordinates.latitude - lowerCoordinates.latitude + regionLatLongBuffer;
    locationSpan.longitudeDelta = upperCoordinates.longitude - lowerCoordinates.longitude + regionLatLongBuffer;
    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake((upperCoordinates.latitude+lowerCoordinates.latitude)/2, (upperCoordinates.longitude+lowerCoordinates.longitude)/2);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerPoint, locationSpan);
    [self.mapView setRegion:region animated:animated];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.foundUserOnce) { //don't wnat to change very time the location updates
        //set region on distance from user to game
        [self setMapViewZoomForGameWithLocation:userLocation.location animated:YES];
    }
    
    self.foundUserOnce = YES;
}

- (void)setLatLongGameLocation:(CLLocationCoordinate2D)latLongGameLocation {
    if (_latLongGameLocation.latitude != latLongGameLocation.latitude || _latLongGameLocation.longitude != latLongGameLocation.longitude) {
        _latLongGameLocation = latLongGameLocation;
        
        //remove old annotations
        [self.mapView removeAnnotations:[self.mapView annotations]];
        //add new location pin
        MKPointAnnotation *gameLocationPin = [[MKPointAnnotation alloc] init];
        gameLocationPin.coordinate = self.latLongGameLocation;
        [self.mapView addAnnotation:gameLocationPin];
    }
    
//    [self.mapView setCenterCoordinate:_latLongGameLocation animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (id view in views) {
        if ([view isKindOfClass:[MKPinAnnotationView class]]) {
            [view setAnimatesDrop:NO];
            [view setDraggable:NO];
        }
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.mapView toExtentOfParent:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
