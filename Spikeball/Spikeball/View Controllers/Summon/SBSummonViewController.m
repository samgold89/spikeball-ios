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

@interface SBSummonViewController () <MKMapViewDelegate>

@property (nonatomic,assign) NSInteger unhideBarsInFlight;
@property (nonatomic,strong) MKMapView *mapView;

@end

@implementation SBSummonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:UIBarButtonItemStylePlain target:self action:@selector(favoritesButtonPressed)]];
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"geo_button"] style:UIBarButtonItemStylePlain target:self action:@selector(geoButtonPressed)]];
    
    self.unhideBarsInFlight = 0;
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView.userLocation setTitle:@"You are here!"];
    self.mapView.delegate = self;
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
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.navigationController.navigationBar setFrame:CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//        [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
//    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    self.unhideBarsInFlight += 1;
//    NSLog(@"unhide %lu",self.unhideBarsInFlight);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.unhideBarsInFlight -= 1;
//        NSLog(@"UNHIDE %lu",self.unhideBarsInFlight);
//        if (self.unhideBarsInFlight == 0) {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self.navigationController.navigationBar setFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//                [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
//            }];
//        }
//    });
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
