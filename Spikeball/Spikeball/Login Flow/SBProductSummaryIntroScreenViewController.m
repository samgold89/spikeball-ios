//
//  SBProductSummaryIntroScreenViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBProductSummaryIntroScreenViewController.h"
#import "SBLibrary.h"
#import "SBLoginViewController.h"

@interface SBProductSummaryIntroScreenViewController ()

@property (nonatomic,strong) UIScrollView *textScrollView;
@property (nonatomic,strong) UIView *gradientOverlayView;

@property (nonatomic,strong) UILabel *soundTheHornLabel;
@property (nonatomic,strong) UILabel *hornDescriptionLabel;
@property (nonatomic,strong) UILabel *heedTheCallLabel;
@property (nonatomic,strong) UILabel *heedDescriptionLabel;

@property (nonatomic,strong) UIButton *getStartedButton;

@property (nonatomic,strong) NSArray *gradientConstraints;
@property (nonatomic,strong) NSMutableArray *buttonConstraints;
@property (nonatomic,assign) BOOL animatingToLogin;

@end

@implementation SBProductSummaryIntroScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor spikeballYellow];
    
    self.textScrollView = [[UIScrollView alloc] init];
    self.textScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.textScrollView];
    
    UIFont *titleFont = [UIFont fontWithName:SBFontStandard size:27];
    UIFont *textFont = [UIFont fontWithName:SBFontStandard size:14];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    self.soundTheHornLabel = [[UILabel alloc] init];
    self.soundTheHornLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.soundTheHornLabel.text = @"Sound The Horn";
    self.soundTheHornLabel.textAlignment = NSTextAlignmentCenter;
    self.soundTheHornLabel.font = titleFont;
    self.soundTheHornLabel.textColor = [UIColor spikeballBlack];
    [self.textScrollView addSubview:self.soundTheHornLabel];
    
    self.hornDescriptionLabel = [[UILabel alloc] init];
    self.hornDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.hornDescriptionLabel.numberOfLines = 0;
    self.hornDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"You open the app, tell us where you’re going to play, and we tell the world. We’ll let you know how many people to expect, and you take care of the rest." attributes:@{NSForegroundColorAttributeName:[UIColor spikeballBlack], NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle}];
    [self.textScrollView addSubview:self.hornDescriptionLabel];
    
    self.heedTheCallLabel = [[UILabel alloc] init];
    self.heedTheCallLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.heedTheCallLabel.text = @"Heed the Call";
    self.heedTheCallLabel.textAlignment = NSTextAlignmentCenter;
    self.heedTheCallLabel.font = titleFont;
    self.heedTheCallLabel.textColor = [UIColor spikeballBlack];
    [self.textScrollView addSubview:self.heedTheCallLabel];
    
    self.heedDescriptionLabel = [[UILabel alloc] init];
    self.heedDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.heedDescriptionLabel.numberOfLines = 0;
//    self.heedDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn.Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn." attributes:@{NSForegroundColorAttributeName:[UIColor spikeballBlack], NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle}];
    self.heedDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Now we need to know where you’d like to play! Select areas on the map, and we’ll let you know when other Spikeballers sound the horn." attributes:@{NSForegroundColorAttributeName:[UIColor spikeballBlack], NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle}];
    [self.textScrollView addSubview:self.heedDescriptionLabel];
    
    self.gradientOverlayView = [[UIView alloc] init];
    self.gradientOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gradientOverlayView.userInteractionEnabled = NO;
    self.gradientOverlayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.gradientOverlayView];
    
    self.getStartedButton = [[UIButton alloc] init];
    self.getStartedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
    [self.getStartedButton setTitleColor:[UIColor spikeballYellow] forState:UIControlStateNormal];
    self.getStartedButton.layer.masksToBounds = YES;
    self.getStartedButton.layer.cornerRadius = 7;
    self.getStartedButton.layer.borderColor = [UIColor spikeballYellow].CGColor;
    self.getStartedButton.layer.borderWidth = 1;
    [self.getStartedButton addTarget:self action:@selector(getStartedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getStartedButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    CGFloat bufferValue = 20;
    
    [NSLayoutConstraint sidesOfChild:self.textScrollView toSidesOfParent:self.view];
    [NSLayoutConstraint topOfChild:self.textScrollView toTopOfParent:self.view withFixedMargin:2*bufferValue];
    [NSLayoutConstraint bottomOfChild:self.textScrollView toTopOfSibling:self.getStartedButton withFixedMargin:-bufferValue inParent:self.view];
    
    [NSLayoutConstraint centerXOfChild:self.soundTheHornLabel toCenterXOfParent:self.textScrollView];
    [NSLayoutConstraint sidesOfChild:self.soundTheHornLabel toSidesOfParent:self.textScrollView margin:2*bufferValue];
    [NSLayoutConstraint topOfChild:self.soundTheHornLabel toTopOfParent:self.textScrollView];
    
    [NSLayoutConstraint centerXOfChild:self.hornDescriptionLabel toCenterXOfParent:self.textScrollView];
    [NSLayoutConstraint sidesOfChild:self.hornDescriptionLabel toSidesOfParent:self.textScrollView margin:2*bufferValue];
    [NSLayoutConstraint topOfChild:self.hornDescriptionLabel toBottomOfSibling:self.soundTheHornLabel withFixedMargin:bufferValue inParent:self.textScrollView];
    
    [NSLayoutConstraint centerXOfChild:self.heedTheCallLabel toCenterXOfParent:self.textScrollView];
    [NSLayoutConstraint sidesOfChild:self.heedTheCallLabel toSidesOfParent:self.textScrollView margin:2*bufferValue];
    [NSLayoutConstraint topOfChild:self.heedTheCallLabel toBottomOfSibling:self.hornDescriptionLabel withFixedMargin:2*bufferValue inParent:self.textScrollView];
    
    [NSLayoutConstraint centerXOfChild:self.heedDescriptionLabel toCenterXOfParent:self.textScrollView];
    [NSLayoutConstraint sidesOfChild:self.heedDescriptionLabel toSidesOfParent:self.textScrollView margin:2*bufferValue];
    [NSLayoutConstraint topOfChild:self.heedDescriptionLabel toBottomOfSibling:self.heedTheCallLabel withFixedMargin:bufferValue inParent:self.textScrollView];
    
    self.buttonConstraints = [@[] mutableCopy];
    [self.buttonConstraints addObject:[NSLayoutConstraint view:self.getStartedButton toFixedHeight:44]];
    [self.buttonConstraints addObjectsFromArray:[NSLayoutConstraint sidesOfChild:self.getStartedButton toSidesOfParent:self.view margin:40]];
    [self.buttonConstraints addObject:[NSLayoutConstraint bottomOfChild:self.getStartedButton toBottomOfParent:self.view withFixedMargin:-20]];
    
    self.gradientConstraints = [NSLayoutConstraint extentOfChild:self.gradientOverlayView toExtentOfParent:self.view];
}

- (void)getStartedButtonPressed {
    self.animatingToLogin = YES;
    [NSLayoutConstraint deactivateConstraints:self.gradientConstraints];
    self.gradientOverlayView.translatesAutoresizingMaskIntoConstraints = YES;
    self.gradientOverlayView.frame = self.view.bounds;
    
    [NSLayoutConstraint deactivateConstraints:self.buttonConstraints];
    self.getStartedButton.translatesAutoresizingMaskIntoConstraints = YES;
//    self.getStartedButton.frame = self.view.bounds;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.textScrollView.alpha = 0;
        self.getStartedButton.frame = CGRectMake(self.getStartedButton.frame.origin.x, self.view.frame.size.height+30, self.getStartedButton.frame.size.width, self.getStartedButton.frame.size.height);
        self.getStartedButton.alpha = 0;
    } completion:^(BOOL finished) {
        SBLoginViewController *login = [[SBLoginViewController alloc] init];
        [login willMoveToParentViewController:self];
        [self addChildViewController:login];
        [login didMoveToParentViewController:self];
        
        login.view.frame = self.view.bounds;
        login.view.center = CGPointMake(login.view.center.x, login.view.center.y+login.view.frame.size.height);
        [self.view addSubview:login.view];
        
        [UIView animateWithDuration:0.6 animations:^{
            self.gradientOverlayView.center = CGPointMake(self.gradientOverlayView.center.x, self.gradientOverlayView.center.y-self.view.frame.size.height);
            login.view.frame = self.view.bounds;
        }];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.animatingToLogin) {
        CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
        gradient.startPoint = CGPointMake(0.5, 1);
        gradient.endPoint = CGPointMake(0.5, 0.4);
        gradient.colors = @[(id)[UIColor spikeballBlack].CGColor, (id)[UIColor clearColor].CGColor];
        gradient.frame = self.gradientOverlayView.bounds;
        [self.gradientOverlayView.layer addSublayer:gradient];
        
        self.textScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.heedDescriptionLabel.frame.origin.y+self.heedDescriptionLabel.frame.size.height);
        self.textScrollView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
