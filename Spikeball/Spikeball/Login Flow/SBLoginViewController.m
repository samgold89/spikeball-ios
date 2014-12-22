//
//  SBLoginViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 11/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBLoginViewController.h"
#import "SBEmailAndNameViewController.h"
#import "SBLocationAndNotificationsViewController.h"
#import "SBAnimatingLogo.h"
#import "SBLibrary.h"

@interface SBLoginViewController () <SBEmailAndNameViewControllerDelegate>

@property (nonatomic,strong) UIImageView *gradientBackgroundImageView;

@property (nonatomic,strong) UIButton *bigLogo;

@property (nonatomic,strong) NSMutableArray *bigLogoConstraints;
@property (nonatomic,strong) NSMutableArray *smallLogoConstraints;

@property (nonatomic,strong) NSLayoutConstraint *accountConstraint;

@property (nonatomic,strong) UIPanGestureRecognizer *panner;
@property (nonatomic,assign) CGFloat previousPanX;

@property (nonatomic,strong) SBEmailAndNameViewController *emailAndNameViewController;
@property (nonatomic,strong) SBLocationAndNotificationsViewController *locationAndNotificationsViewController;

@end

static NSInteger kBigLogoHeight = 191;
static CGFloat kSmallLogoHeight = 80;
static CGFloat kEmailOffset = 0;

@implementation SBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bigLogoConstraints = [@[] mutableCopy];
    self.smallLogoConstraints = [@[] mutableCopy];
    
    self.gradientBackgroundImageView = [[UIImageView alloc] init];
    self.gradientBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gradientBackgroundImageView.image = [UIImage imageNamed:@"black_to_yellow_gradient"];
    [self.view addSubview:self.gradientBackgroundImageView];
    
    UIImage *ig = [UIImage imageNamed:@"spikeball_yellow_logo_launch"];
    self.bigLogo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ig.size.width, ig.size.height)];
    [self.bigLogo setImage:ig forState:UIControlStateNormal];
    self.bigLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bigLogo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shrinkLogoShowTopContainer];
    });
    
    self.emailAndNameViewController = [[SBEmailAndNameViewController alloc] init];
    self.emailAndNameViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailAndNameViewController.delegate = self;
    [self.view addSubview:self.emailAndNameViewController.view];
    [self.emailAndNameViewController willMoveToParentViewController:self];
    [self addChildViewController:self.emailAndNameViewController];
    [self.emailAndNameViewController didMoveToParentViewController:self];
    
    self.locationAndNotificationsViewController = [[SBLocationAndNotificationsViewController alloc] init];
    [self.view addSubview:self.locationAndNotificationsViewController.view];
    self.locationAndNotificationsViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationAndNotificationsViewController willMoveToParentViewController:self];
    [self addChildViewController:self.locationAndNotificationsViewController];
    [self.locationAndNotificationsViewController didMoveToParentViewController:self];
    
    self.panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannerPanned:)];
    self.panner.enabled = NO;
    [self.view addGestureRecognizer:self.panner];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.gradientBackgroundImageView toExtentOfParent:self.view];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [NSLayoutConstraint view:self.emailAndNameViewController.view toFixedWidth:screenWidth];
    self.accountConstraint = [NSLayoutConstraint leftOfChild:self.emailAndNameViewController.view toLeftOfParent:self.view withFixedMargin:kEmailOffset];
    [NSLayoutConstraint bottomOfChild:self.emailAndNameViewController.view toBottomOfParent:self.view];
    [NSLayoutConstraint topOfChild:self.emailAndNameViewController.view toBottomOfSibling:self.bigLogo withFixedMargin:kTextFieldHeight/2 inParent:self.view];
    
    [NSLayoutConstraint view:self.locationAndNotificationsViewController.view toFixedWidth:screenWidth];
    [NSLayoutConstraint leftOfChild:self.locationAndNotificationsViewController.view toRightOfSibling:self.emailAndNameViewController.view withFixedMargin:0 inParent:self.view];
    [NSLayoutConstraint topOfChild:self.locationAndNotificationsViewController.view toTopOfSibling:self.emailAndNameViewController.view withFixedMargin:0 inParent:self.view];
    [NSLayoutConstraint bottomOfChild:self.locationAndNotificationsViewController.view toBottomOfSibling:self.emailAndNameViewController.view withFixedMargin:0 inParent:self.view];

    //LOGO constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSLayoutConstraint *bigCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-103.];
    
    NSLayoutConstraint *smallCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-205];
    NSLayoutConstraint *smallLogoHeightConstraint = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kSmallLogoHeight];
    NSLayoutConstraint *smallLogoWidthConstraing = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kSmallLogoHeight];
    
    [self.smallLogoConstraints addObjectsFromArray:@[smallCenterYConstraint,smallLogoHeightConstraint,smallLogoWidthConstraing]];
    [self.view addConstraints:self.smallLogoConstraints];
    [NSLayoutConstraint deactivateConstraints:self.smallLogoConstraints];
    [self.view addConstraint:bigCenterYConstraint];
    [self.bigLogoConstraints addObject:bigCenterYConstraint];
}

- (void)shrinkLogoShowTopContainer {
    [NSLayoutConstraint deactivateConstraints:self.bigLogoConstraints];
    [NSLayoutConstraint activateConstraints:self.smallLogoConstraints];
   
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
        [self.emailAndNameViewController setTopContainerHidden:NO animated:NO];
        [self.emailAndNameViewController setBottomContainerHidden:YES animated:NO];
    } completion:nil];
}

- (void)pannerPanned:(UIPanGestureRecognizer*)pan {
    CGFloat xLocation = [pan locationInView:self.view].x;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.previousPanX = xLocation;
            [self.emailAndNameViewController endAllEditing];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat xDiff = self.previousPanX-xLocation;
            self.emailAndNameViewController.view.center = CGPointMake(self.emailAndNameViewController.view.center.x - xDiff, self.emailAndNameViewController.view.center.y);
            self.locationAndNotificationsViewController.view.center = CGPointMake(self.locationAndNotificationsViewController.view.center.x - xDiff, self.locationAndNotificationsViewController.view.center.y);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGFloat xVelocity = [pan velocityInView:self.view].x;
            if (xVelocity < 0) {
                [self moveToLocationView];
            } else if (xVelocity > 0) {
                [self moveToAccountView];
            } else if (self.emailAndNameViewController.view.center.x < 0) {
                [self moveToLocationView];
            } else {
                [self moveToLocationView];
            }
        }
            break;
            
        default:
            break;
    }
    self.previousPanX = xLocation;
}

- (void)moveToLocationView {
    self.accountConstraint.constant = -[[UIScreen mainScreen] bounds].size.width;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)moveToAccountView {
    self.accountConstraint.constant = 0;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraints];
        [self.view layoutIfNeeded];

    } completion:nil];
}

#pragma mark Account View Delegate
- (void)moveToLocationPushView {
    [self moveToLocationView];
}

- (void)translateViewByValue:(CGFloat)shift {
    self.view.transform = CGAffineTransformMakeTranslation(0, -shift+self.view.transform.ty);
}

- (void)restoreViewToIdentity {
    self.view.transform = CGAffineTransformIdentity;
}

- (void)setPannerEnabled:(BOOL)enabled {
    self.panner.enabled = enabled;
}

- (void)updateLocationWithName:(NSString *)name {
    self.locationAndNotificationsViewController.topNameabel.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
