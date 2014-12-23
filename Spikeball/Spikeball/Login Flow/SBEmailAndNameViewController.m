//
//  SBEmailAndNameViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/21/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBEmailAndNameViewController.h"
#import "SBLibrary.h"
#import "SBAnimatingLogo.h"

@interface SBEmailAndNameViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIView *topAccountContainerView;
@property (nonatomic,strong) UIView *bottomNameContainerView;

@property (nonatomic,strong) UITapGestureRecognizer *keyboardDismisser;

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

@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIView *middleLoginDivider;

@property (nonatomic,strong) UIButton *createAccountButton;

@end

//static CGFloat kTextFieldHeight = 44;
static CGFloat kFieldBufferValue = 10;

@implementation SBEmailAndNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    NSInteger titleFontSize = 15;
    UIFont *placholderFont = [UIFont fontWithName:SBFontStandard size:15];
    
    //TOP STUFF
    self.accountTitleLabel = [[UILabel alloc] init];
    self.accountTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountTitleLabel.text = @"Account";
    self.accountTitleLabel.textColor = [UIColor spikeballYellow];
    self.accountTitleLabel.font = [UIFont fontWithName:SBFontStandardBold size:titleFontSize];
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
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email - we will never spam you" attributes:@{NSForegroundColorAttributeName : transparentYellow, NSFontAttributeName : placholderFont}];
    self.emailTextField.textColor = [UIColor spikeballYellow];
    self.emailTextField.tintColor = [UIColor spikeballYellow];
    self.emailTextField.delegate = self;
    [self.topAccountContainerView addSubview:self.emailTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName : transparentYellow, NSFontAttributeName : placholderFont}];
    self.passwordTextField.textColor = [UIColor spikeballYellow];
    self.passwordTextField.tintColor = [UIColor spikeballYellow];
    self.passwordTextField.delegate = self;
    [self.topAccountContainerView addSubview:self.passwordTextField];
    
    self.passwordRepeatTextField = [[UITextField alloc] init];
    self.passwordRepeatTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordRepeatTextField.returnKeyType = UIReturnKeyNext;
    self.passwordRepeatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordRepeatTextField.secureTextEntry = YES;
    self.passwordRepeatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{NSForegroundColorAttributeName : transparentYellow, NSFontAttributeName : placholderFont}];
    self.passwordRepeatTextField.textColor = [UIColor spikeballYellow];
    self.passwordTextField.tintColor = [UIColor spikeballYellow];
    self.passwordRepeatTextField.delegate = self;
    [self.topAccountContainerView addSubview:self.passwordRepeatTextField];
    
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = placholderFont;
    [self.loginButton setTitleColor:[UIColor spikeballYellow] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    //BOTTOM STUFF
    self.enterNameLabel = [[UILabel alloc] init];
    self.enterNameLabel.text = @"Enter Your Name";
    self.enterNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
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
    self.firstNameTextField.tintColor = [UIColor spikeballBlack];
    self.firstNameTextField.delegate = self;
    [self.bottomNameContainerView addSubview:self.firstNameTextField];
    
    self.lastNameTextField = [[UITextField alloc] init];
    self.lastNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameTextField.returnKeyType = UIReturnKeyNext;
    self.lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName : transparentSpikeballBlack, NSFontAttributeName : placholderFont}];
    self.lastNameTextField.textColor = [UIColor spikeballBlack];
    self.lastNameTextField.tintColor = [UIColor spikeballBlack];
    self.lastNameTextField.delegate = self;
    [self.bottomNameContainerView addSubview:self.lastNameTextField];
    
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.nicknameTextField.returnKeyType = UIReturnKeyDone;
    self.nicknameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nicknameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nickname (optional)" attributes:@{NSForegroundColorAttributeName : transparentSpikeballBlack, NSFontAttributeName : placholderFont}];
    self.nicknameTextField.textAlignment = NSTextAlignmentCenter;
    self.nicknameTextField.textColor = [UIColor spikeballBlack];
    self.nicknameTextField.tintColor = [UIColor spikeballBlack];
    self.nicknameTextField.delegate = self;
    [self.bottomNameContainerView addSubview:self.nicknameTextField];
    
    self.createAccountButton = [[UIButton alloc] init];
    self.createAccountButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [self.createAccountButton setTitleColor:[UIColor spikeballBlack] forState:UIControlStateNormal];
    [self.createAccountButton addTarget:self action:@selector(createNewAccountButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.createAccountButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.createAccountButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:15];
    self.createAccountButton.layer.masksToBounds = YES;
    self.createAccountButton.layer.cornerRadius = 7;
    self.createAccountButton.layer.borderColor = [UIColor spikeballBlack].CGColor;
    self.createAccountButton.layer.borderWidth = 1;
    [self.view addSubview:self.createAccountButton];
    
    [self setupConstraints];
    [self setTopContainerHidden:YES animated:NO];
    [self setBottomContainerHidden:YES animated:NO];
    [self setNextButtonHidden:YES animated:NO];
}

- (void)setupConstraints {
//    [NSLayoutConstraint centerXOfChild:self.createAccountButton toCenterXOfParent:self.view];
    CGFloat buttonBuffer = 20;
    [NSLayoutConstraint sidesOfChild:self.createAccountButton toSidesOfParent:self.view margin:buttonBuffer*2];
    [NSLayoutConstraint view:self.createAccountButton toFixedHeight:kTextFieldHeight];
    [NSLayoutConstraint bottomOfChild:self.createAccountButton toBottomOfParent:self.view withFixedMargin:-buttonBuffer];
    
    //CONTAINER Setup
    [NSLayoutConstraint topOfChild:self.topAccountContainerView toTopOfParent:self.view];
    [NSLayoutConstraint view:self.topAccountContainerView toFixedHeight:kTextFieldHeight*2.5]; //2 rows plus title height
    [NSLayoutConstraint sidesOfChild:self.topAccountContainerView toSidesOfParent:self.view];
    
    [NSLayoutConstraint topOfChild:self.bottomNameContainerView toBottomOfSibling:self.topAccountContainerView withFixedMargin:kTextFieldHeight inParent:self.view];
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
    
    //TOP login buttons
    [NSLayoutConstraint centerXOfChild:self.loginButton toCenterXOfParent:self.view];
    [NSLayoutConstraint topOfChild:self.loginButton toBottomOfSibling:self.topAccountContainerView withFixedMargin:20 inParent:self.view];
    
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setNextButtonHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTopContainerHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [UIView animateWithDuration:animated ? 0.8 : 0 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.topAccountContainerView.transform = CGAffineTransformMakeScale(1, 0.001);
            self.topAccountContainerView.alpha = 0;
        } completion:nil];
    } else {
        [UIView animateWithDuration:animated ? 0.8 : 0 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.topAccountContainerView.transform = CGAffineTransformIdentity;
            self.topAccountContainerView.alpha = 1;
        } completion:nil];
    }
}

- (void)setBottomContainerHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [UIView animateWithDuration:animated ? 0.8 : 0 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bottomNameContainerView.transform = CGAffineTransformMakeScale(1, 0.001);
            self.bottomNameContainerView.alpha = 0;
        } completion:nil];
    } else {
        [UIView animateWithDuration:animated ? 0.8 : 0 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bottomNameContainerView.transform = CGAffineTransformIdentity;
            self.bottomNameContainerView.alpha = 1;
        } completion:nil];
    }
}

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [self.passwordRepeatTextField becomeFirstResponder];
    } else if ([self validateAccountTextFields]) {
        if ([textField isEqual:self.passwordRepeatTextField]) {
            [self.firstNameTextField becomeFirstResponder];
        } else if ([textField isEqual:self.firstNameTextField]) {
            [self.lastNameTextField becomeFirstResponder];
        } else if ([textField isEqual:self.lastNameTextField]) {
            [self.nicknameTextField becomeFirstResponder];
        } else if ([textField isEqual:self.nicknameTextField]) {
            [self.nicknameTextField resignFirstResponder];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.emailTextField] && [string isEqualToString:@" "]) { //NO SPACES allowed in email
        return NO;
    }
    
    NSString *proposedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = proposedString;
    BOOL validAccount = [self validateAccountTextFields];
    BOOL validName = [self validateNameTextFields];
    
    [self setBottomContainerHidden:!validAccount animated:YES];
    [self setNameInLocationView];
    if (validAccount && validName) {
        [self setNextButtonHidden:NO animated:YES];
    } else {
        [self setNextButtonHidden:YES animated:YES];
    }
    
    [self setBottomLoginButtonBasedOnFields];
    
    return NO;
}

- (void)setNextButtonHidden:(BOOL)hide animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.8 : 0 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (hide) {
            self.createAccountButton.layer.transform = CATransform3DMakeTranslation(0, 100, 0);
        } else {
            self.createAccountButton.layer.transform = CATransform3DIdentity;
        }
    } completion:nil];
}

- (BOOL)validateAccountTextFields {
    BOOL validEmail = [self.emailTextField.text isValidEmailAddress];
    BOOL validPassword = [self.passwordTextField.text isValidPassword];
    BOOL passwordsMatch = [self.passwordTextField.text isEqualToString:self.passwordRepeatTextField.text];
    
    return validEmail && validPassword && passwordsMatch;
}

- (BOOL)validateNameTextFields {
    BOOL validFirstName = self.firstNameTextField.text.length >1;
    BOOL validLastName = self.lastNameTextField.text.length > 1;
    BOOL validNickname = self.nicknameTextField.text.length > 1;
    
    return validFirstName || validLastName || validNickname;
}

- (void)setNameInLocationView {
    NSString *currentName = @"";
    if (self.nicknameTextField.text.length > 1) {
        currentName = self.nicknameTextField.text;
    } else if (self.firstNameTextField.text.length > 1) {
        currentName = self.firstNameTextField.text;
    } else if (self.lastNameTextField.text.length > 1) {
        currentName = self.lastNameTextField.text;
    }
    if ([self.delegate respondsToSelector:@selector(updateLocationWithName:)]) {
        [self.delegate updateLocationWithName:currentName];
    }
}

#pragma mark Button Handlers
- (void)setBottomLoginButtonBasedOnFields {
    BOOL hide;
    NSString *buttonText;
    if (![self.emailTextField.text isValidEmailAddress] && ![self.emailTextField isFirstResponder]) { //invalid email
        hide = NO;
        buttonText = @"Invalid email address";
        self.loginButton.enabled = NO;
    } else if (self.passwordRepeatTextField.text.length == 0) { //login button
        hide = NO;
        buttonText = @"Login";
        self.loginButton.enabled = YES;
    } else if (![self.passwordTextField isFirstResponder] && ![self.passwordTextField.text isValidPassword]) {
        hide = NO;
        buttonText = @"Password must be at least 5 characters!";
        self.loginButton.enabled = NO;
    } else if (![self.passwordRepeatTextField.text isEqualToString:self.passwordTextField.text]) { //passwords don't match
        hide = NO;
        buttonText = @"Passwords don't match";
        self.loginButton.enabled = NO;
    } else { //hide it!
        hide = [self.passwordTextField isFirstResponder];
    }
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loginButton.transform = hide ? CGAffineTransformMakeScale(0.01, 0.01) : CGAffineTransformIdentity;
        [self.loginButton setTitle:buttonText forState:UIControlStateNormal];
        self.loginButton.alpha = !hide;
    } completion:^(BOOL finished) {
        if (hide) {
            self.loginButton.alpha = 0;
        }
    }];
}

- (void)loginButtonPressed {
    
}

- (void)createNewAccountButtonPressed {
    //TODO: wait on Eli's dumb ass to set up the create user endpoint
    self.view.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(animateTopLogo)]) {
        [self.delegate animateTopLogo];
    }
    
    //TODO: on callback, remove loader and progress
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(stopAnimatingTopLogo)]) {
            [self.delegate stopAnimatingTopLogo];
        }
        if ([self.delegate respondsToSelector:@selector(moveToLocationAndPush)]) {
            [self.delegate moveToLocationAndPush];
        }
    });
}

- (void)keyboardWillChangeFrame:(NSNotification*)note {
    if (!self.keyboardDismisser) {
        self.keyboardDismisser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAllEditing)];
        [self.view addGestureRecognizer:self.keyboardDismisser];
    }
    
    NSDictionary *keyboardDict = note.userInfo;
    CGRect finalKeyboardFrame = [[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convTopRect = [self.view.window convertRect:self.topAccountContainerView.frame fromView:self.view];
    CGRect convBottomRect = [self.view.window convertRect:self.bottomNameContainerView.frame fromView:self.view];
    
    BOOL isTopContainer = [self.emailTextField isFirstResponder] || [self.passwordRepeatTextField isFirstResponder] || [self.passwordTextField isFirstResponder];
    CGRect inter = CGRectIntersection(isTopContainer ? convTopRect : convBottomRect, finalKeyboardFrame);
    if (!CGRectIsNull(inter)) {
        CGFloat distanceToMove = inter.size.height + 20;
        [UIView animateWithDuration:[keyboardDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[keyboardDict[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
            if ([self.delegate respondsToSelector:@selector(translateViewByValue:)]) {
                [self.delegate translateViewByValue:distanceToMove];
            }
        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification*)note {
    [self.view removeGestureRecognizer:self.keyboardDismisser];
    self.keyboardDismisser = nil;
    
    NSDictionary *keyboardDict = note.userInfo;
    [UIView animateWithDuration:[keyboardDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[keyboardDict[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        if ([self.delegate respondsToSelector:@selector(restoreViewToIdentity)]) {
            [self.delegate restoreViewToIdentity];
        }
    } completion:nil];
}

- (void)endAllEditing {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordRepeatTextField resignFirstResponder];
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end