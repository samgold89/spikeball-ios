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
#import "SBViewConstants.h"
#import <NSLayoutConstraint+HAWHelpers/NSLayoutConstraint+HAWHelpers.h>

@interface SBLoginViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *gradientBackgroundImageView;

@property (nonatomic,strong) UIButton *bigLogo;
@property (nonatomic,strong) UILabel *heedTheCall;
@property (nonatomic,strong) UILabel *footerLabel;

@property (nonatomic,strong) NSMutableArray *bigLogoConstraints;
@property (nonatomic,strong) NSMutableArray *smallLogoConstraints;

@property (nonatomic,strong) UIView *topAccountContainerView;
@property (nonatomic,strong) UIView *bottomNameContainerView;

@property (nonatomic,strong) UILabel *accountTitleLabel;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UITextField *passwordRepeatTextField;
@property (nonatomic,strong) UIView *accountTopBorder;
@property (nonatomic,strong) UIView *accountMiddleBorder;
@property (nonatomic,strong) UIView *accountBottomBorder;
@property (nonatomic,strong) UIView *accountMiddleDivider;

@property (nonatomic,strong) UILabel *enterNameLabel;
@property (nonatomic,strong) UITextField *firstNameTextField;
@property (nonatomic,strong) UITextField *lastNameTextField;
@property (nonatomic,strong) UITextField *nicknameTextField;
@property (nonatomic,strong) UIView *nameTopBorder;
@property (nonatomic,strong) UIView *nameMiddleBorder;
@property (nonatomic,strong) UIView *nameBottomBorder;
@property (nonatomic,strong) UIView *nameMiddleDivider;

@end

static NSInteger kBigLogoHeight = 191;
static CGFloat kSmallLogoHeight = 80;
static CGFloat kTextFieldHeight = 44;
static CGFloat kFieldBufferValue = 10;

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
    [self.bigLogo addTarget:self action:@selector(logoTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bigLogo];
    
    self.topAccountContainerView = [[UIView alloc] init];
    self.topAccountContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topAccountContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topAccountContainerView];
    
    self.bottomNameContainerView = [[UIView alloc] init];
    self.bottomNameContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomNameContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomNameContainerView];
    
    UIColor *transparentYellow = [[UIColor spikeballYellow] colorWithAlphaComponent:0.7];
    UIColor *transparentSpikeballBlack = [[UIColor spikeballBlack] colorWithAlphaComponent:0.5];
    NSInteger titleFontSize = 14;
    UIFont *placholderFont = [UIFont fontWithName:SBFontStandard size:15];
    
    //TOP STUFF
    self.accountTitleLabel = [[UILabel alloc] init];
    self.accountTitleLabel.text = @"Account";
    self.accountTitleLabel.textColor = [UIColor spikeballYellow];
    self.accountTitleLabel.font = [UIFont fontWithName:SBFontStandard size:titleFontSize];
    [self.topAccountContainerView addSubview:self.accountTitleLabel];
    
    self.accountTopBorder = [[UIView alloc] init];
    self.accountTopBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountTopBorder.backgroundColor = transparentYellow;
    [self.topAccountContainerView addSubview:self.accountTopBorder];
    
    self.accountMiddleDivider = [[UIView alloc] init];
    self.accountMiddleDivider.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountMiddleDivider.backgroundColor = transparentYellow;
    [self.topAccountContainerView addSubview:self.accountMiddleDivider];
    
    self.accountMiddleBorder = [[UIView alloc] init];
    self.accountMiddleBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountMiddleBorder.backgroundColor = transparentYellow;
    [self.topAccountContainerView addSubview:self.accountMiddleBorder];
    
    self.accountBottomBorder = [[UIView alloc] init];
    self.accountBottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountBottomBorder.backgroundColor = transparentYellow;
    [self.topAccountContainerView addSubview:self.accountBottomBorder];
    
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email - we will never spam you" attributes:@{NSForegroundColorAttributeName : transparentYellow, NSFontAttributeName : placholderFont}];
    self.emailTextField.textColor = [UIColor spikeballYellow];
    self.emailTextField.delegate = self;
    [self.topAccountContainerView addSubview:self.emailTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName : transparentYellow, NSFontAttributeName : placholderFont}];
    self.passwordTextField.textColor = [UIColor spikeballYellow];
    self.passwordTextField.delegate = self;
    [self.topAccountContainerView addSubview:self.passwordTextField];
    
    self.passwordRepeatTextField = [[UITextField alloc] init];
    self.passwordRepeatTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordRepeatTextField.returnKeyType = UIReturnKeyNext;
    self.passwordRepeatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordRepeatTextField.secureTextEntry = YES;
    self.passwordRepeatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{NSForegroundColorAttributeName : transparentYellow, NSFontAttributeName : placholderFont}];
    self.passwordRepeatTextField.textColor = [UIColor spikeballYellow];
    self.passwordRepeatTextField.delegate = self;
    [self.topAccountContainerView addSubview:self.passwordRepeatTextField];
    
    //BOTTOM STUFF
    self.enterNameLabel = [[UILabel alloc] init];
    self.enterNameLabel.text = @"Enter Your Name";
    self.enterNameLabel.textColor = [UIColor spikeballBlack];
    self.enterNameLabel.font = [UIFont fontWithName:SBFontStandard size:titleFontSize];
    [self.bottomNameContainerView addSubview:self.enterNameLabel];
    
    self.nameTopBorder = [[UIView alloc] init];
    self.nameTopBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTopBorder.backgroundColor = transparentSpikeballBlack;
    [self.bottomNameContainerView addSubview:self.nameTopBorder];
    
    self.nameMiddleDivider = [[UIView alloc] init];
    self.nameMiddleDivider.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameMiddleDivider.backgroundColor = transparentSpikeballBlack;
    [self.bottomNameContainerView addSubview:self.nameMiddleDivider];
    
    self.nameMiddleBorder = [[UIView alloc] init];
    self.nameMiddleBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameMiddleBorder.backgroundColor = transparentSpikeballBlack;
    [self.bottomNameContainerView addSubview:self.nameMiddleBorder];
    
    self.nameBottomBorder = [[UIView alloc] init];
    self.nameBottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameBottomBorder.backgroundColor = transparentSpikeballBlack;
    [self.bottomNameContainerView addSubview:self.nameBottomBorder];
    
    self.firstNameTextField = [[UITextField alloc] init];
    self.firstNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.firstNameTextField.returnKeyType = UIReturnKeyNext;
    self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName : transparentSpikeballBlack, NSFontAttributeName : placholderFont}];
    self.firstNameTextField.textColor = [UIColor spikeballBlack];
    self.firstNameTextField.delegate = self;
    [self.bottomNameContainerView addSubview:self.firstNameTextField];
    
    self.lastNameTextField = [[UITextField alloc] init];
    self.lastNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameTextField.returnKeyType = UIReturnKeyNext;
    self.lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName : transparentSpikeballBlack, NSFontAttributeName : placholderFont}];
    self.lastNameTextField.textColor = [UIColor spikeballBlack];
    self.lastNameTextField.delegate = self;
    [self.bottomNameContainerView addSubview:self.lastNameTextField];
    
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.nicknameTextField.returnKeyType = UIReturnKeyDone;
    self.nicknameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nicknameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nickname" attributes:@{NSForegroundColorAttributeName : transparentSpikeballBlack, NSFontAttributeName : placholderFont}];
    self.nicknameTextField.textAlignment = NSTextAlignmentCenter;
    self.nicknameTextField.textColor = [UIColor spikeballBlack];
    self.nicknameTextField.delegate = self;
    [self.bottomNameContainerView addSubview:self.nicknameTextField];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.gradientBackgroundImageView toExtentOfParent:self.view];
    
    //CONTAINER Setup
    [NSLayoutConstraint topOfChild:self.topAccountContainerView toBottomOfSibling:self.bigLogo withFixedMargin:kTextFieldHeight/2 inParent:self.view];
    [NSLayoutConstraint view:self.topAccountContainerView toFixedHeight:kTextFieldHeight*2.5]; //2 rows plus title height
    [NSLayoutConstraint sidesOfChild:self.topAccountContainerView toSidesOfParent:self.view];
    
    [NSLayoutConstraint topOfChild:self.bottomNameContainerView toBottomOfSibling:self.topAccountContainerView withFixedMargin:kTextFieldHeight*2 inParent:self.view];
    [NSLayoutConstraint view:self.bottomNameContainerView toFixedHeight:kTextFieldHeight*2.5]; //2 rows plus title height
    [NSLayoutConstraint sidesOfChild:self.bottomNameContainerView toSidesOfParent:self.view];
    
    //BORDER LINES SETUP
    CGFloat borderLineHeight = 1;
    [NSLayoutConstraint sidesOfChild:self.accountTopBorder toSidesOfParent:self.topAccountContainerView];
    [NSLayoutConstraint sidesOfChild:self.accountBottomBorder toSidesOfParent:self.topAccountContainerView];
    [NSLayoutConstraint sidesOfChild:self.accountMiddleBorder toSidesOfParent:self.topAccountContainerView];
    [NSLayoutConstraint view:self.accountBottomBorder toFixedHeight:borderLineHeight];
    [NSLayoutConstraint view:self.accountTopBorder toFixedHeight:borderLineHeight];
    [NSLayoutConstraint view:self.accountMiddleBorder toFixedHeight:borderLineHeight];
    [NSLayoutConstraint view:self.accountMiddleDivider toFixedWidth:borderLineHeight];
    
    [NSLayoutConstraint sidesOfChild:self.nameTopBorder toSidesOfParent:self.bottomNameContainerView];
    [NSLayoutConstraint sidesOfChild:self.nameBottomBorder toSidesOfParent:self.bottomNameContainerView];
    [NSLayoutConstraint sidesOfChild:self.nameMiddleBorder toSidesOfParent:self.bottomNameContainerView];
    [NSLayoutConstraint view:self.nameBottomBorder toFixedHeight:borderLineHeight];
    [NSLayoutConstraint view:self.nameTopBorder toFixedHeight:borderLineHeight];
    [NSLayoutConstraint view:self.nameMiddleBorder toFixedHeight:borderLineHeight];
    [NSLayoutConstraint view:self.nameMiddleDivider toFixedWidth:borderLineHeight];
    
    //TOP / Account fields
    [NSLayoutConstraint centerXOfChild:self.accountTitleLabel toCenterXOfParent:self.topAccountContainerView];
    [NSLayoutConstraint topOfChild:self.accountTitleLabel toTopOfParent:self.topAccountContainerView];
    
    [NSLayoutConstraint topOfChild:self.emailTextField toBottomOfSibling:self.accountTitleLabel withFixedMargin:kFieldBufferValue inParent:self.topAccountContainerView];
    [NSLayoutConstraint sidesOfChild:self.emailTextField toSidesOfParent:self.topAccountContainerView margin:kFieldBufferValue];
    [NSLayoutConstraint view:self.emailTextField toFixedHeight:kTextFieldHeight];
    [NSLayoutConstraint topOfChild:self.emailTextField toBottomOfSibling:self.accountTitleLabel withFixedMargin:kFieldBufferValue inParent:self.topAccountContainerView];
    
    [NSLayoutConstraint topOfChild:self.passwordTextField toBottomOfSibling:self.emailTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint leftOfChild:self.passwordTextField toLeftOfParent:self.topAccountContainerView withFixedMargin:kFieldBufferValue];
    [NSLayoutConstraint rightOfChild:self.passwordTextField toLeftOfSibling:self.accountMiddleDivider withFixedMargin:kFieldBufferValue inParent:self.topAccountContainerView];
    [NSLayoutConstraint view:self.passwordTextField toFixedHeight:kTextFieldHeight];
    
    [NSLayoutConstraint topOfChild:self.passwordRepeatTextField toTopOfSibling:self.passwordTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint leftOfChild:self.passwordRepeatTextField toRightOfSibling:self.accountMiddleDivider withFixedMargin:kFieldBufferValue inParent:self.topAccountContainerView];
    [NSLayoutConstraint rightOfChild:self.passwordRepeatTextField toRightOfParent:self.topAccountContainerView withFixedMargin:kFieldBufferValue];
    [NSLayoutConstraint view:self.passwordRepeatTextField toFixedHeight:kTextFieldHeight];
    
    [NSLayoutConstraint topOfChild:self.accountTopBorder toTopOfSibling:self.emailTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint topOfChild:self.accountMiddleBorder toTopOfSibling:self.passwordTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint bottomOfChild:self.accountBottomBorder toBottomOfSibling:self.passwordTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint topOfChild:self.accountMiddleDivider toTopOfSibling:self.passwordTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint bottomOfChild:self.accountMiddleDivider toBottomOfSibling:self.passwordTextField withFixedMargin:0 inParent:self.topAccountContainerView];
    [NSLayoutConstraint centerXOfChild:self.accountMiddleDivider toCenterXOfParent:self.topAccountContainerView];
    
    //BOTTOM / Name fields
    [NSLayoutConstraint centerXOfChild:self.enterNameLabel toCenterXOfParent:self.bottomNameContainerView];
    [NSLayoutConstraint topOfChild:self.enterNameLabel toTopOfParent:self.bottomNameContainerView];
    
    [NSLayoutConstraint topOfChild:self.firstNameTextField toBottomOfSibling:self.enterNameLabel withFixedMargin:kFieldBufferValue inParent:self.bottomNameContainerView];
    [NSLayoutConstraint leftOfChild:self.firstNameTextField toLeftOfParent:self.bottomNameContainerView withFixedMargin:kFieldBufferValue];
    [NSLayoutConstraint rightOfChild:self.firstNameTextField toLeftOfSibling:self.nameMiddleDivider withFixedMargin:kFieldBufferValue inParent:self.bottomNameContainerView];
    [NSLayoutConstraint view:self.firstNameTextField toFixedHeight:kTextFieldHeight];
    
    [NSLayoutConstraint topOfChild:self.lastNameTextField toTopOfSibling:self.firstNameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    [NSLayoutConstraint leftOfChild:self.lastNameTextField toRightOfSibling:self.nameMiddleDivider withFixedMargin:kFieldBufferValue inParent:self.bottomNameContainerView];
    [NSLayoutConstraint rightOfChild:self.lastNameTextField toRightOfParent:self.bottomNameContainerView withFixedMargin:kFieldBufferValue];
    [NSLayoutConstraint view:self.lastNameTextField toFixedHeight:kTextFieldHeight];
    
    [NSLayoutConstraint sidesOfChild:self.nicknameTextField toSidesOfParent:self.bottomNameContainerView margin:kFieldBufferValue];
    [NSLayoutConstraint view:self.nicknameTextField toFixedHeight:kTextFieldHeight];
    [NSLayoutConstraint topOfChild:self.nicknameTextField toBottomOfSibling:self.firstNameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    
    [NSLayoutConstraint topOfChild:self.nameTopBorder toTopOfSibling:self.firstNameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    [NSLayoutConstraint topOfChild:self.nameMiddleBorder toTopOfSibling:self.nicknameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    [NSLayoutConstraint bottomOfChild:self.nameBottomBorder toBottomOfSibling:self.nicknameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    [NSLayoutConstraint topOfChild:self.nameMiddleDivider toTopOfSibling:self.firstNameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    [NSLayoutConstraint bottomOfChild:self.nameMiddleDivider toBottomOfSibling:self.firstNameTextField withFixedMargin:0 inParent:self.bottomNameContainerView];
    [NSLayoutConstraint centerXOfChild:self.nameMiddleDivider toCenterXOfParent:self.bottomNameContainerView];

    //LOGO constraints
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

- (void)logoTouched:(id)sender {
    UIButton *button = sender;
    if (button.selected) { //go big
        [NSLayoutConstraint deactivateConstraints:self.smallLogoConstraints];
        [NSLayoutConstraint activateConstraints:self.bigLogoConstraints];
    } else { //go small
        [NSLayoutConstraint deactivateConstraints:self.bigLogoConstraints];
        [NSLayoutConstraint activateConstraints:self.smallLogoConstraints];
    }
    button.selected = !button.selected;
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [self.passwordRepeatTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordRepeatTextField]) {
        [self.firstNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameTextField]) {
        [self.nicknameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.nicknameTextField]) {
        [self.nicknameTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.emailTextField] && [string isEqualToString:@" "]) { //NO SPACES allowed in email
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
