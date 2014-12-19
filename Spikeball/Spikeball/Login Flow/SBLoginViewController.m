//
//  SBLoginViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 11/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBLoginViewController.h"
#import "UIColor+SpikeballColors.h"
#import "SBAnimatingLogo.h"

@interface SBLoginViewController ()

@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) UIView *gradientBackgroundView;

@property (nonatomic,strong) UIButton *bigLogo;
@property (nonatomic,strong) UILabel *heedTheCall;
@property (nonatomic,strong) UILabel *footerLabel;

@property (nonatomic,strong) NSMutableArray *bigLogoConstraints;
@property (nonatomic,strong) NSMutableArray *smallLogoConstraints;

@end

static NSInteger kBigLogoHeight = 191;
static CGFloat kSmallLogoHeight = 84;

@implementation SBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bigLogoConstraints = [@[] mutableCopy];
    self.smallLogoConstraints = [@[] mutableCopy];
    
    self.gradientBackgroundView = [[UIView alloc] init];
    self.gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gradientBackgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.gradientBackgroundView];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[(id)[UIColor blackColor].CGColor];
    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
    
    UIImage *ig = [UIImage imageNamed:@"spikeball_yellow_logo_launch"];
    self.bigLogo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ig.size.width, ig.size.height)];
    [self.bigLogo setImage:ig forState:UIControlStateNormal];
    self.bigLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bigLogo addTarget:self action:@selector(logoTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bigLogo];
    
    [self setupConstraints];
    
    SBAnimatingLogo *logo = [[SBAnimatingLogo alloc] initWithFrame:CGRectMake(30, 350, 100, 100)];
    [self.view addSubview:logo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self animateToBlackToYellow];
    });
}

- (void)setupConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientBackgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientBackgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientBackgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSLayoutConstraint *bigCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100];
    
    NSLayoutConstraint *smallCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-205];
    NSLayoutConstraint *smallLogoHeightConstraint = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kSmallLogoHeight];
    NSLayoutConstraint *smallLogoWidthConstraing = [NSLayoutConstraint constraintWithItem:self.bigLogo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kSmallLogoHeight];
    
    [self.smallLogoConstraints addObjectsFromArray:@[smallCenterYConstraint,smallLogoHeightConstraint,smallLogoWidthConstraing]];
    [self.view addConstraints:self.smallLogoConstraints];
    [NSLayoutConstraint deactivateConstraints:self.smallLogoConstraints];
    [self.view addConstraint:bigCenterYConstraint];
    [self.bigLogoConstraints addObject:bigCenterYConstraint];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.gradientLayer.frame = CGRectMake(0, 0, self.gradientBackgroundView.frame.size.width, self.gradientBackgroundView.frame.size.height);
}

- (void)animateToBlackToYellow {
    CGFloat duration = 5;
    
    NSArray *gradLocations = @[@0,@0.7];
    NSArray *gradColors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor spikeballYellow].CGColor];
    
    CABasicAnimation *locationSwap = [CABasicAnimation animationWithKeyPath:@"locations"];
    locationSwap.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    locationSwap.duration = duration;
    locationSwap.fromValue = self.gradientLayer.locations;
    locationSwap.toValue = gradLocations;
    locationSwap.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *colorSwap = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorSwap.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    colorSwap.duration = duration;
    colorSwap.fromValue = self.gradientLayer.colors;
    colorSwap.toValue = gradColors;
    colorSwap.fillMode = kCAFillModeForwards;
    
    NSLog(@"NOW");
    self.gradientLayer.colors = gradColors;
    self.gradientLayer.locations = gradLocations;
    
    [self.gradientLayer addAnimation:locationSwap forKey:@"locations"];
    [self.gradientLayer addAnimation:colorSwap forKey:@"colors"];
}

- (void)logoTouched:(id)sender {
    UIButton *button = sender;
    if (button.selected) {
        [NSLayoutConstraint deactivateConstraints:self.smallLogoConstraints];
        [NSLayoutConstraint activateConstraints:self.bigLogoConstraints];
    } else {
        [NSLayoutConstraint deactivateConstraints:self.bigLogoConstraints];
        [NSLayoutConstraint activateConstraints:self.smallLogoConstraints];
    }
    button.selected = !button.selected;
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
