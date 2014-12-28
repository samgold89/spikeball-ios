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
#import "SBGameDetailsViewController.h"

@interface SBSummonViewController () <MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) SBGameDetailsViewController *gameDetailsViewController;

@end

@implementation SBSummonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate requestLocationAccess];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self setBarButtonsForSummoning];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView.userLocation setTitle:@"You are here!"];
    [self.view addSubview:self.mapView];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dropPinFromLongPress:)];
    [self.mapView addGestureRecognizer:longPress];

    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.mapView toExtentOfParent:self.view];
}

#pragma mark Annotation Handlers
- (void)dropPinFromLongPress:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.gameDetailsViewController = [[SBGameDetailsViewController alloc] init];
            self.gameDetailsViewController.delegate = self;
            self.gameDetailsViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.gameDetailsViewController willMoveToParentViewController:self];
            [self addChildViewController:self.gameDetailsViewController];
            [self.gameDetailsViewController didMoveToParentViewController:self];
            self.gameDetailsViewController.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
            [self.view addSubview:self.gameDetailsViewController.view];
            
            [NSLayoutConstraint topOfChild:self.gameDetailsViewController.view toBottomOfSibling:self.navigationController.navigationBar withFixedMargin:0 inParent:self.view.window];
            [NSLayoutConstraint bottomOfChild:self.gameDetailsViewController.view toBottomOfParent:self.view];
            [NSLayoutConstraint sidesOfChild:self.gameDetailsViewController.view toSidesOfParent:self.view];
            
            [UIView animateWithDuration:0.35 animations:^{
                self.gameDetailsViewController.view.transform = CGAffineTransformIdentity;
                self.navigationController.tabBarController.tabBar.center = CGPointMake(self.navigationController.tabBarController.tabBar.center.x, self.navigationController.tabBarController.tabBar.center.y+self.navigationController.tabBarController.tabBar.frame.size.height);
            } completion:^(BOOL finished) {
                [self.gameDetailsViewController setLayoutConstants];
            }];
            
            [self setBarButtonsForGameDetials];
        }}
    /*
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
            CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
            [self getInformationForCoordinate:touchMapCoordinate];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = touchMapCoordinate;
            [self.mapView addAnnotation:annotation];
        }
            
            break;
            
        default:
            break;
    }
     */
}

- (void)getInformationForCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"NAME OF LOCATION :: %@",[[placemarks firstObject] name]);
    }];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (id view in views) {
        if ([view isKindOfClass:[MKPinAnnotationView class]]) {
            [view setAnimatesDrop:YES];
            [view setDraggable:YES];
        } else {
            ((UIView*)view).transform = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
                ((UIView*)view).transform = CGAffineTransformIdentity;
            } completion:nil];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"SELECT");
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"DESSELC");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [view setCanShowCallout:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    switch (newState) {
        case MKAnnotationViewDragStateEnding:
            [self getInformationForCoordinate:view.annotation.coordinate];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Nav Bar Button Handlers
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
    if (self.gameDetailsViewController) return; //if the game details is showing, just return
    
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

#pragma mark Navigation Bar Button Handling 
- (void)setBarButtonsForGameDetials {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissGameDetailsRight)] animated:YES];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)setBarButtonsForSummoning {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"geo_button_selected"] style:UIBarButtonItemStylePlain target:self action:@selector(geoButtonSelectedPressed)] animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:UIBarButtonItemStylePlain target:self action:@selector(favoritesButtonPressed)] animated:YES];
}

- (void)dismissViewControllerDown {
    [self dismissGameDetailsDown:YES];
}

- (void)dismissGameDetailsRight {
    [self dismissGameDetailsDown:NO];
}

- (void)dismissGameDetailsDown:(BOOL)down {
    [self setBarButtonsForSummoning];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.gameDetailsViewController.view.center = CGPointMake(self.gameDetailsViewController.view.center.x+self.view.frame.size.width*(down ? 0 : 1), self.gameDetailsViewController.view.center.y+self.view.frame.size.height*(down ? 1 : 0));
        self.navigationController.tabBarController.tabBar.center = CGPointMake(self.navigationController.tabBarController.tabBar.center.x, self.navigationController.tabBarController.tabBar.center.y-self.navigationController.tabBarController.tabBar.frame.size.height);
    } completion:^(BOOL finished) {
        [self.gameDetailsViewController.view removeFromSuperview];
        [self.gameDetailsViewController willMoveToParentViewController:nil];
        [self.gameDetailsViewController removeFromParentViewController];
        [self.gameDetailsViewController didMoveToParentViewController:nil];
    }];
}

@end
