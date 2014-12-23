//
//  SBLoginCompleteViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBLoginCompleteViewController.h"
#import "SBLibrary.h"
#import "AppDelegate.h"

@interface SBLoginCompleteViewController ()

@property (nonatomic,strong) UILabel *congatulatoryLabel;
@property (nonatomic,strong) UIImageView *spikeballNetImageView;
@property (nonatomic,strong) UIButton *startSpikingButton;
@property (nonatomic,strong) UIView *invisibleSpacerView;
@property (nonatomic,strong) UIButton *inviteFriendsButton;

@end

@implementation SBLoginCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.congatulatoryLabel = [[UILabel alloc] init];
    self.congatulatoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.congatulatoryLabel.text = @"You did it! Time to\nhave some fun.";
    self.congatulatoryLabel.font = [UIFont fontWithName:SBFontStandard size:27];
    self.congatulatoryLabel.numberOfLines = 2;
    self.congatulatoryLabel.textColor = [UIColor spikeballYellow];
    self.congatulatoryLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.congatulatoryLabel];
    
    self.spikeballNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spikeball_net_with_shadow"]];
    self.spikeballNetImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spikeballNetImageView];
    
    self.startSpikingButton = [[UIButton alloc] init];
    self.startSpikingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startSpikingButton setTitle:@"Start Spiking" forState:UIControlStateNormal];
    self.startSpikingButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
    [self.startSpikingButton addTarget:self action:@selector(startSpikingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.startSpikingButton setTitleColor:[UIColor spikeballBlack] forState:UIControlStateNormal];
    self.startSpikingButton.layer.masksToBounds = YES;
    self.startSpikingButton.layer.cornerRadius = 7;
    self.startSpikingButton.layer.borderColor = [UIColor spikeballBlack].CGColor;
    self.startSpikingButton.layer.borderWidth = 1;
    [self.view addSubview:self.startSpikingButton];
    
    self.invisibleSpacerView = [[UIView alloc] init];
    self.invisibleSpacerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.invisibleSpacerView.hidden = YES;
    [self.view addSubview:self.invisibleSpacerView];
    
    self.inviteFriendsButton = [[UIButton alloc] init];
    self.inviteFriendsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.inviteFriendsButton setTitle:@"Invite Friends" forState:UIControlStateNormal];
    [self.inviteFriendsButton setTitleColor:[UIColor spikeballBlack] forState:UIControlStateNormal];
    [self.inviteFriendsButton addTarget:self action:@selector(inviteFriendsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.inviteFriendsButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
    self.inviteFriendsButton.layer.masksToBounds = YES;
    self.inviteFriendsButton.layer.cornerRadius = 7;
    self.inviteFriendsButton.layer.borderColor = [UIColor spikeballBlack].CGColor;
    self.inviteFriendsButton.layer.borderWidth = 1;
    [self.view addSubview:self.inviteFriendsButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint topOfChild:self.congatulatoryLabel toTopOfParent:self.view withFixedMargin:5];
    [NSLayoutConstraint centerXOfChild:self.congatulatoryLabel toCenterXOfParent:self.view];
    
    [NSLayoutConstraint bottomOfChild:self.spikeballNetImageView toTopOfSibling:self.startSpikingButton withFixedMargin:IS_IPHONE_4 ? 40 : -10 inParent:self.view];
    [NSLayoutConstraint centerXOfChild:self.spikeballNetImageView toCenterXOfParent:self.view withFixedMargin:36]; //image is off center
    
    CGFloat buttonHeight = 44;
    CGFloat buttonMargin = 15;
    
    [NSLayoutConstraint view:self.startSpikingButton toFixedHeight:buttonHeight];
    [NSLayoutConstraint leftOfChild:self.startSpikingButton toRightOfSibling:self.invisibleSpacerView withFixedMargin:buttonMargin/2 inParent:self.view];
    [NSLayoutConstraint rightOfChild:self.startSpikingButton toRightOfParent:self.view withFixedMargin:-buttonMargin];
    [NSLayoutConstraint bottomOfChild:self.startSpikingButton toBottomOfParent:self.view withFixedMargin:-buttonMargin];
    
    [NSLayoutConstraint centerOfChild:self.invisibleSpacerView toCenterOfParent:self.view];
    [NSLayoutConstraint view:self.invisibleSpacerView toFixedWidth:1];
    
    [NSLayoutConstraint view:self.inviteFriendsButton toFixedHeight:buttonHeight];
    [NSLayoutConstraint rightOfChild:self.inviteFriendsButton toLeftOfSibling:self.invisibleSpacerView withFixedMargin:-buttonMargin/2 inParent:self.view];
    [NSLayoutConstraint leftOfChild:self.inviteFriendsButton toLeftOfParent:self.view withFixedMargin:buttonMargin];
    [NSLayoutConstraint bottomOfChild:self.inviteFriendsButton toBottomOfParent:self.view withFixedMargin:-buttonMargin];
}

- (void)startSpikingButtonPressed {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setupRootViewControllersFromLogin:YES];
}

- (void)inviteFriendsButtonPressed {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
