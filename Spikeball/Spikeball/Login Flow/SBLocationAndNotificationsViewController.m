//
//  SBLocationAndNotificationsViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/21/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBLocationAndNotificationsViewController.h"
#import "SBLibrary.h"
#import "SBAnimatingLogo.h"
#import "AppDelegate.h"

static CGFloat kLabelToButtonBuffer = 18;
@interface SBLocationAndNotificationsViewController ()

@property (nonatomic,strong) UILabel *fakeLabel;

@property (nonatomic,strong) UIView *nameTopBorder;
@property (nonatomic,strong) UILabel *topNameabel;
@property (nonatomic,strong) UIView *nameBottomBorder;

@property (nonatomic,strong) UILabel *locationPrompt;
@property (nonatomic,strong) UIButton *locationButton;
@property (nonatomic,strong) UIImageView *locationStatusImageView;
@property (nonatomic,strong) SBAnimatingLogo *locationLoading;
@property (nonatomic,assign) BOOL locationResultReceived;

@property (nonatomic,strong) UILabel *notificationPrompt;
@property (nonatomic,strong) UIButton *notificationButton;
@property (nonatomic,strong) UIImageView *notificationStatusImageView;
@property (nonatomic,strong) SBAnimatingLogo *notificationLoading;
@property (nonatomic,assign) BOOL notificationResultReceived;

@end

@implementation SBLocationAndNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegisterForPush:) name:SBNotificationDidRegisterForPushNotifications object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToRegisterForPush:) name:SBNotificationFailedToRegisterForPushNotifications object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegisterForLocation:) name:SBNotificationDidRegisterForLocationServices object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToRegisterForLocation:) name:SBNotificationFailedToRegisterForLocationServices object:nil];
    
    self.view.backgroundColor = [UIColor clearColor];
    UIColor *transparentYellow = [[UIColor spikeballYellow] colorWithAlphaComponent:0.7];
    
    self.fakeLabel = [[UILabel alloc] init];
    self.fakeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fakeLabel.text = @"WhoCares";
    self.fakeLabel.font = [UIFont fontWithName:SBFontStandardBold size:15   ];
    self.fakeLabel.alpha = 0;
    [self.view addSubview:self.fakeLabel];
    
    self.nameTopBorder = [[UIView alloc] init];
    self.nameTopBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTopBorder.backgroundColor = transparentYellow;
    [self.view addSubview:self.nameTopBorder];
    
    self.topNameabel = [[UILabel alloc] init];
    self.topNameabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.topNameabel.font = [UIFont fontWithName:SBFontStandard size:15];
    self.topNameabel.textColor = [UIColor spikeballYellow];
    [self.view addSubview:self.topNameabel];
    
    self.nameBottomBorder = [[UIView alloc] init];
    self.nameBottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameBottomBorder.backgroundColor = transparentYellow;
    [self.view addSubview:self.nameBottomBorder];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:7];
    
    self.locationPrompt = [[UILabel alloc] init];
    self.locationPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationPrompt.adjustsFontSizeToFitWidth = YES;

    self.locationPrompt.attributedText = [[NSAttributedString alloc] initWithString:@"Summon needs your location to determine which games are nearby. We will never share your location with anybody - especially your ex!" attributes:@{NSFontAttributeName:[UIFont fontWithName:SBFontStandard size:14],NSForegroundColorAttributeName:[UIColor spikeballBlack],NSParagraphStyleAttributeName:paragrahStyle}];
    self.locationPrompt.textAlignment = NSTextAlignmentCenter;
    self.locationPrompt.numberOfLines = 0;
    [self.view addSubview:self.locationPrompt];
    
    UIFont *buttonFont = [UIFont fontWithName:SBFontStandard size:18];
    
    self.locationButton = [[UIButton alloc] init];
    self.locationButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationButton.layer.masksToBounds = YES;
    self.locationButton.layer.cornerRadius = 7;
    self.locationButton.layer.borderColor = [UIColor spikeballBlack].CGColor;
    self.locationButton.layer.borderWidth = 1;
    [self.locationButton setTitle:@"Share Location" forState:UIControlStateNormal];
    [self.locationButton setTitleColor:[UIColor spikeballBlack] forState:UIControlStateNormal];
    self.locationButton.titleLabel.font = buttonFont;
    [self.locationButton addTarget:self action:@selector(shareLocationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.locationButton];
    
    self.locationStatusImageView = [[UIImageView alloc] init];
    self.locationStatusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationStatusImageView setImage:[UIImage imageNamed:@"white_checkmark"]];
    self.locationStatusImageView.alpha = 0;
    [self.view addSubview:self.locationStatusImageView];
    
    self.notificationPrompt = [[UILabel alloc] init];
    self.notificationPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    self.notificationPrompt.adjustsFontSizeToFitWidth = YES;
    self.notificationPrompt.attributedText = [[NSAttributedString alloc] initWithString:@"Summon uses push notifications to let you know the time and place of nearby games." attributes:@{NSFontAttributeName:[UIFont fontWithName:SBFontStandard size:14],NSForegroundColorAttributeName:[UIColor spikeballBlack],NSParagraphStyleAttributeName:paragrahStyle}];
    self.notificationPrompt.textAlignment = NSTextAlignmentCenter;
    self.notificationPrompt.numberOfLines = 0;
    [self.view addSubview:self.notificationPrompt];
    
    self.notificationButton = [[UIButton alloc] init];
    self.notificationButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.notificationButton.layer.masksToBounds = YES;
    self.notificationButton.layer.cornerRadius = 7;
    [self.notificationButton setTitle:@"Enable Notifications" forState:UIControlStateNormal];
    [self.notificationButton setTitleColor:[UIColor spikeballBlack] forState:UIControlStateNormal];
    self.notificationButton.titleLabel.font = buttonFont;
    self.notificationButton.layer.borderColor = [UIColor spikeballBlack].CGColor;
    self.notificationButton.layer.borderWidth = 1;
    [self.notificationButton addTarget:self action:@selector(notificationButtonPresesed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.notificationButton];
    
    self.notificationStatusImageView = [[UIImageView alloc] init];
    self.notificationStatusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.notificationStatusImageView setImage:[UIImage imageNamed:@"white_checkmark"]];
    self.notificationStatusImageView.alpha = 0;
    [self.view addSubview:self.notificationStatusImageView];
    
    [self setupHiddenTransforms];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint centerXOfChild:self.fakeLabel toCenterXOfParent:self.view];
    [NSLayoutConstraint topOfChild:self.fakeLabel toTopOfParent:self.view];
    
    [NSLayoutConstraint sidesOfChild:self.nameTopBorder toSidesOfParent:self.view];
    [NSLayoutConstraint view:self.nameTopBorder toFixedHeight:1];
    [NSLayoutConstraint topOfChild:self.nameTopBorder toBottomOfSibling:self.fakeLabel withFixedMargin:10/*kFieldBufferValue*/ inParent:self.view];
    
    [NSLayoutConstraint view:self.topNameabel toFixedHeight:44/*kTextFieldHeight*/];
    [NSLayoutConstraint centerXOfChild:self.topNameabel toCenterXOfParent:self.view];
    [NSLayoutConstraint topOfChild:self.topNameabel toBottomOfSibling:self.nameTopBorder withFixedMargin:0 inParent:self.view];
    
    [NSLayoutConstraint sidesOfChild:self.nameBottomBorder toSidesOfParent:self.view];
    [NSLayoutConstraint view:self.nameBottomBorder toFixedHeight:1];
    [NSLayoutConstraint bottomOfChild:self.nameBottomBorder toBottomOfSibling:self.topNameabel withFixedMargin:0 inParent:self.view];
    
    CGFloat labelSideMargin = 30;
    CGFloat buttonHeight = 43;
    [NSLayoutConstraint sidesOfChild:self.locationPrompt toSidesOfParent:self.view margin:labelSideMargin];
    [NSLayoutConstraint topOfChild:self.locationPrompt toBottomOfSibling:self.nameBottomBorder withFixedMargin:2*kLabelToButtonBuffer inParent:self.view];
    
    [NSLayoutConstraint sidesOfChild:self.locationButton toSidesOfParent:self.view margin:20];
    [NSLayoutConstraint topOfChild:self.locationButton toBottomOfSibling:self.locationPrompt withFixedMargin:kLabelToButtonBuffer inParent:self.view];
    [NSLayoutConstraint view:self.locationButton toFixedHeight:buttonHeight];
    
    [NSLayoutConstraint centerYOfChild:self.locationStatusImageView toCenterYOfSibling:self.locationButton inParent:self.view];
    [NSLayoutConstraint rightOfChild:self.locationStatusImageView toRightOfSibling:self.locationButton withFixedMargin:-10 inParent:self.view];
    
    if (IS_IPHONE_4) { //iphone 4 we'll stack 'em on top of each other
        [NSLayoutConstraint sidesOfChild:self.notificationPrompt toSidesOfParent:self.view margin:labelSideMargin];
        [NSLayoutConstraint topOfChild:self.notificationPrompt toBottomOfSibling:self.nameBottomBorder withFixedMargin:2*kLabelToButtonBuffer inParent:self.view];
        
        [NSLayoutConstraint sidesOfChild:self.notificationButton toSidesOfParent:self.view margin:20];
        [NSLayoutConstraint topOfChild:self.notificationButton toBottomOfSibling:self.notificationPrompt withFixedMargin:kLabelToButtonBuffer inParent:self.view];
        [NSLayoutConstraint view:self.notificationButton toFixedHeight:buttonHeight];
        
        self.notificationPrompt.alpha = self.notificationButton.alpha = 0;
    } else {
        [NSLayoutConstraint sidesOfChild:self.notificationPrompt toSidesOfParent:self.view margin:labelSideMargin];
        [NSLayoutConstraint topOfChild:self.notificationPrompt toBottomOfSibling:self.locationButton withFixedMargin:2*kLabelToButtonBuffer inParent:self.view];
        
        [NSLayoutConstraint sidesOfChild:self.notificationButton toSidesOfParent:self.view margin:20];
        [NSLayoutConstraint topOfChild:self.notificationButton toBottomOfSibling:self.notificationPrompt withFixedMargin:kLabelToButtonBuffer inParent:self.view];
        [NSLayoutConstraint view:self.notificationButton toFixedHeight:buttonHeight];
    }
    
    [NSLayoutConstraint centerYOfChild:self.notificationStatusImageView toCenterYOfSibling:self.notificationButton inParent:self.view];
    [NSLayoutConstraint rightOfChild:self.notificationStatusImageView toRightOfSibling:self.notificationButton withFixedMargin:-10 inParent:self.view];
}

- (void)setupHiddenTransforms {
    self.fakeLabel.transform = self.locationPrompt.transform = self.locationButton.transform = self.locationStatusImageView.transform = self.locationLoading.transform = self.notificationPrompt.transform = self.notificationButton.transform = self.notificationStatusImageView.transform = self.notificationLoading.transform =
    CGAffineTransformMakeScale(0.01, 0.01);
}

- (void)showAllContent {
    int counter = 0;
    for (UIView *view in @[self.fakeLabel,self.locationPrompt, self.locationButton, self.locationStatusImageView, self.notificationPrompt, self.notificationButton, self.notificationStatusImageView]) {
        [UIView animateWithDuration:0.7 delay:0.04*counter usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:nil];
        counter += 1;
    }
}

- (void)shareLocationButtonPressed:(id)sender {
    if (self.locationLoading) {
        [self.locationLoading removeFromSuperview];
        self.locationLoading = nil;
    }
    self.locationLoading = [[SBAnimatingLogo alloc] initWithFrame:self.locationStatusImageView.bounds andLogoColor:[UIColor whiteColor]];
    self.locationLoading.center = self.locationStatusImageView.center;
    [self.view addSubview:self.locationLoading];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) requestLocationAccess];
}

- (void)notificationButtonPresesed:(id)sender {
    if (self.notificationLoading) {
        [self.notificationLoading removeFromSuperview];
        self.notificationLoading = nil;
    }
    self.notificationLoading = [[SBAnimatingLogo alloc] initWithFrame:self.notificationStatusImageView.bounds andLogoColor:[UIColor whiteColor]];
    self.notificationLoading.center = self.notificationStatusImageView.center;
    [self.view addSubview:self.notificationLoading];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) registerForPushNotifications];
    
    //TODO: TAKE THIS OUT
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didRegisterForPush:nil];
    });
}

#pragma mark Push & Location NSNotification Handlers
- (void)didRegisterForPush:(NSNotification*)note {
    self.notificationResultReceived = YES;
    
    self.notificationButton.enabled = NO;
    
    self.notificationStatusImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.notificationStatusImageView.alpha = 1;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.notificationStatusImageView.transform = CGAffineTransformIdentity;
        self.notificationLoading.alpha = 0;
        self.notificationLoading.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self checkCompletionAndAdvanceIfReady];
    }];
}

- (void)failedToRegisterForPush:(NSNotification*)note {
//    self.notificationResultReceived = YES;
//    [self checkCompletionAndAdvanceIfReady];
}

- (void)didRegisterForLocation:(NSNotification*)note {
    self.locationResultReceived = YES;
    
    self.locationStatusImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.locationButton.enabled = NO;
    
    self.locationStatusImageView.alpha = 1;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.locationStatusImageView.transform = CGAffineTransformIdentity;
        self.locationLoading.alpha = 0;
        self.locationLoading.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self setLocationsHiddenIfIphone4];
        [self checkCompletionAndAdvanceIfReady];
    }];
}

- (void)failedToRegisterForLocation:(NSNotification*)note {
    [self setLocationsHiddenIfIphone4];
    self.locationResultReceived = YES;
    [self checkCompletionAndAdvanceIfReady];
}

- (void)setLocationsHiddenIfIphone4 {
    if (IS_IPHONE_4) {
        [UIView animateWithDuration:0.4 animations:^{
            self.locationStatusImageView.alpha = self.locationButton.alpha = self.locationPrompt.alpha = 0;
            self.notificationButton.alpha = self.notificationPrompt.alpha = 1;
        }];
    }
}

- (void)checkCompletionAndAdvanceIfReady {
    //ADVANCE TO COMPLETION SCREEN / GET STARTED
    //TODO: go to games if there are games nearby
    //TODO: go to summon if there are no games
    if (self.notificationResultReceived && self.locationResultReceived) {
        if ([self.delegate respondsToSelector:@selector(moveToFinalSummaryView)]) {
            [self.delegate moveToFinalSummaryView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
