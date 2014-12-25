//
//  SBSummonViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBSummonViewController.h"
#import "SBLibrary.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface SBSummonViewController () <MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;

@end

@implementation SBSummonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate requestLocationAccess];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:UIBarButtonItemStylePlain target:self action:@selector(favoritesButtonPressed)]];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView.userLocation setTitle:@"You are here!"];
    [self.view addSubview:self.mapView];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.mapView toExtentOfParent:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)favoritesButtonPressed {
    
}

- (void)geoButtonPressed {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)geoButtonSelectedPressed {
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
}

#pragma mark MapView Delegate Methods
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    switch (mode) {
        case MKUserTrackingModeFollow:
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"geo_button_selected"] style:UIBarButtonItemStylePlain target:self action:@selector(geoButtonSelectedPressed)] animated:YES];
            break;
        case MKUserTrackingModeNone:
        default:
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"geo_button"] style:UIBarButtonItemStylePlain target:self action:@selector(geoButtonPressed)] animated:YES];
            break;
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {

}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {

}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {

}

@end
