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
@property (nonatomic,strong) SBAnimatingLogo *animatingLogo;
@property (nonatomic,strong) UIView *blackOverlay;

@property (nonatomic,strong) NSMutableArray *bigLogoConstraints;
@property (nonatomic,strong) NSMutableArray *smallLogoConstraints;

@property (nonatomic,strong) NSLayoutConstraint *accountConstraint;

@property (nonatomic,strong) SBEmailAndNameViewController *emailAndNameViewController;
@property (nonatomic,strong) SBLocationAndNotificationsViewController *locationAndNotificationsViewController;

@end

static NSInteger kBigLogoHeight = 191;
static CGFloat kSmallLogoHeight = 80;
static CGFloat kEmailOffset = 0;

@implementation SBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
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

- (void)moveToLocationView {
    self.accountConstraint.constant = -[[UIScreen mainScreen] bounds].size.width;
    CGFloat animationTime = 0.8;
    [UIView animateWithDuration:animationTime delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.locationAndNotificationsViewController showAllContent];
    }];
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
- (void)animateTopLogo {
    if (self.animatingLogo) {
        [self.animatingLogo removeFromSuperview];
        self.animatingLogo = nil;
    }
    if (self.blackOverlay) {
        [self.blackOverlay removeFromSuperview];
        self.blackOverlay = nil;
    }
    
    self.blackOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
    self.blackOverlay.backgroundColor = [[UIColor spikeballBlack] colorWithAlphaComponent:0.35];
    self.blackOverlay.alpha = 0;
    [self.view addSubview:self.blackOverlay];
    
    self.animatingLogo = [[SBAnimatingLogo alloc] initWithFrame:self.bigLogo.bounds];
    self.animatingLogo.center = self.bigLogo.center;
    self.animatingLogo.alpha = 0;
    [self.view addSubview:self.animatingLogo];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.animatingLogo.alpha = 1;
        self.blackOverlay.alpha = 1;
        self.bigLogo.alpha = 0;
    }];
}

- (void)stopAnimatingTopLogo {
    [UIView animateWithDuration:0.3 animations:^{
        self.animatingLogo.alpha = 0;
        self.blackOverlay.alpha = 0;
        self.bigLogo.alpha = 1;
    } completion:^(BOOL finished) {
        [self.animatingLogo removeFromSuperview];
        self.animatingLogo = nil;
        [self.blackOverlay removeFromSuperview];
        self.blackOverlay = nil;
    }];
}

- (void)moveToLocationAndPush {
    [self moveToLocationView];
}

- (void)translateViewByValue:(CGFloat)shift {
    self.view.transform = CGAffineTransformMakeTranslation(0, -shift+self.view.transform.ty);
}

- (void)restoreViewToIdentity {
    self.view.transform = CGAffineTransformIdentity;
}

- (void)updateLocationWithName:(NSString *)name {
    self.locationAndNotificationsViewController.topNameabel.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
