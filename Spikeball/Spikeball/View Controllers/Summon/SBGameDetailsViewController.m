//
//  SBGameDetailsViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/26/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBGameDetailsViewController.h"
#import "SBNumberCollectionViewCell.h"
#import "SBNumberViewFlowLayout.h"
#import "SBLibrary.h"

@interface SBGameDetailsViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> //<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIVisualEffectView *backgroundBlurView;
@property (nonatomic,strong) UIScrollView *scrollContainer;
@property (nonatomic,strong) UIView *scrollableContentContainerView;

@property (nonatomic,strong) UILabel *gameTimeLabel;
@property (nonatomic,strong) UIDatePicker *timePicker;

@property (nonatomic,strong) UILabel *statsLabel;

@property (nonatomic,strong) UIView *statsContainerView;
@property (nonatomic,strong) UILabel *howLongLabel;
@property (nonatomic,strong) UICollectionView *howLongCollectionView;
@property (nonatomic,strong) UIView *topLeftDividerLine;
@property (nonatomic,strong) UIView *topRighttDividerLine;

@property (nonatomic,strong) UIView *collectionViewDividerLine;

@property (nonatomic,strong) UILabel *howManyLabel;
@property (nonatomic,strong) UICollectionView *howManyCollectionView;
@property (nonatomic,strong) UIView *bottomLeftDividerLine;
@property (nonatomic,strong) UIView *bottomRightDividerLine;

@property (nonatomic,strong) UIVisualEffectView *summonButtonContainer;
@property (nonatomic,strong) UIButton *summonButton;
@property (nonatomic,strong) UIImageView *summonImage;

@property (nonatomic,assign) BOOL hasScrolledCollectionViews;
@property (nonatomic,assign) CGFloat effectiveZeroOffset;

@end

static NSInteger kHeaderLabelHeight = 35;
static NSInteger kSideLabelWidth = 107;
static NSInteger kStatsContainerHeight = 147;
static NSString *kCellReuseIdentifier = @"nobodyEverCares";

@implementation SBGameDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.hasScrolledCollectionViews = NO;
    UIColor *transparentBlackColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    
    self.backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.backgroundBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundBlurView];
    
    self.scrollContainer = [[UIScrollView alloc] init];
    self.scrollContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollContainer.showsVerticalScrollIndicator = NO;
    self.scrollContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollContainer];
    
    self.scrollableContentContainerView = [[UIView alloc] init];
    self.scrollableContentContainerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.scrollContainer addSubview:self.scrollableContentContainerView];
    
    self.gameTimeLabel = [[UILabel alloc] init];
    self.gameTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.gameTimeLabel.text = @"Game Time";
    self.gameTimeLabel.textColor = [UIColor blackColor];
    self.gameTimeLabel.font = [UIFont fontWithName:SBFontStandard size:16];
    [self.scrollableContentContainerView addSubview:self.gameTimeLabel];
    
    self.timePicker = [[UIDatePicker alloc] init];
    self.timePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.timePicker.backgroundColor = transparentBlackColor;
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    [self.scrollableContentContainerView addSubview:self.timePicker];
    
    //stats section
    self.statsLabel = [[UILabel alloc] init];
    self.statsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.statsLabel.text = @"Stats";
    self.statsLabel.textColor = self.gameTimeLabel.textColor;
    self.statsLabel.font = self.gameTimeLabel.font;
    [self.scrollableContentContainerView addSubview:self.statsLabel];
    
    self.statsContainerView = [[UIView alloc] init];
    self.statsContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.statsContainerView.backgroundColor = transparentBlackColor;
    [self.scrollableContentContainerView addSubview:self.statsContainerView];
    
    //how long
    self.howLongLabel = [[UILabel alloc] init];
    self.howLongLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.howLongLabel.numberOfLines = 2;
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentCenter;
    NSString *howLongString = @"How Long\n";
    NSString *hoursString = @"(Hours)";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",howLongString,hoursString]];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:SBFontStandard size:18] range:NSMakeRange(0, howLongString.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:SBFontStandard size:13] range:NSMakeRange(howLongString.length, hoursString.length)];
    [attString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, attString.length)];
    self.howLongLabel.attributedText = attString;
    [self.statsContainerView addSubview:self.howLongLabel];
    
    SBNumberViewFlowLayout *flow = [[SBNumberViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(kCellItemWidth, kStatsContainerHeight/2);
    
    self.howLongCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    self.howLongCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.howLongCollectionView.showsHorizontalScrollIndicator = NO;
    self.howLongCollectionView.backgroundColor = [UIColor clearColor];
    self.howLongCollectionView.delegate = self;
    self.howLongCollectionView.dataSource = self;
    [self.statsContainerView addSubview:self.howLongCollectionView];
    
    self.collectionViewDividerLine = [[UIView alloc] init];
    self.collectionViewDividerLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionViewDividerLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.statsContainerView addSubview:self.collectionViewDividerLine];
    
    //how many
    self.howManyLabel = [[UILabel alloc] init];
    self.howManyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.howManyLabel.numberOfLines = 2;
    NSString *howManyString = @"You Are\n";
    NSString *peopleString = @"(# people)";
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",howManyString,peopleString]];
    [attString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:SBFontStandard size:18] range:NSMakeRange(0, howManyString.length)];
    [attString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:SBFontStandard size:13] range:NSMakeRange(howManyString.length, peopleString.length)];
    [attString2 addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, attString.length)];
    self.howManyLabel.attributedText = attString2;
    [self.statsContainerView addSubview:self.howManyLabel];
    
    self.howManyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    self.howManyCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.howManyCollectionView.backgroundColor = [UIColor clearColor];
    self.howManyCollectionView.showsHorizontalScrollIndicator = NO;
    self.howManyCollectionView.delegate = self;
    self.howManyCollectionView.dataSource = self;
    [self.statsContainerView addSubview:self.howManyCollectionView];
    
    self.topLeftDividerLine = [[UIView alloc] init];
    self.topLeftDividerLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.topLeftDividerLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];;
    [self.statsContainerView addSubview:self.topLeftDividerLine];
    
    self.topRighttDividerLine = [[UIView alloc] init];
    self.topRighttDividerLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.topRighttDividerLine.backgroundColor = self.topLeftDividerLine.backgroundColor;
    [self.statsContainerView addSubview:self.topRighttDividerLine];
    
    self.bottomLeftDividerLine = [[UIView alloc] init];
    self.bottomLeftDividerLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomLeftDividerLine.backgroundColor = self.topLeftDividerLine.backgroundColor;
    [self.statsContainerView addSubview:self.bottomLeftDividerLine];
    
    self.bottomRightDividerLine = [[UIView alloc] init];
    self.bottomRightDividerLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomRightDividerLine.backgroundColor = self.topLeftDividerLine.backgroundColor;
    [self.statsContainerView addSubview:self.bottomRightDividerLine];
    
    [self.howManyCollectionView registerClass:[SBNumberCollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    [self.howLongCollectionView registerClass:[SBNumberCollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    self.summonButtonContainer = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.summonButtonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.summonButtonContainer];
    
    self.summonButton = [[UIButton alloc] init];
    self.summonButton.translatesAutoresizingMaskIntoConstraints = NO;
//    self.summonButton.backgroundColor = [[UIColor spikeballBlack] colorWithAlphaComponent:0.95];
    [self.summonButton setTitle:@"Summon" forState:UIControlStateNormal];
    [self.summonButton setTitleColor:[UIColor spikeballYellow] forState:UIControlStateNormal];
    self.summonButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:18];
    [self.summonButton addTarget:self action:@selector(summonButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.summonButtonContainer.contentView addSubview:self.summonButton];
    
    self.summonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"summon_tab_bar"]];
    self.summonImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.summonImage];
    
    [self setupConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollCollectionView:self.howLongCollectionView toIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] animated:NO];
    [self scrollCollectionView:self.howManyCollectionView toIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO];
}

- (void)setLayoutConstants {
    self.scrollContainer.contentSize = CGSizeMake(self.view.frame.size.width, self.statsContainerView.frame.origin.y+self.statsContainerView.frame.size.height+self.summonButton.frame.size.height+10);
    self.scrollableContentContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.effectiveZeroOffset = self.howManyCollectionView.frame.size.width/2-kCellItemWidth/2;
    self.howManyCollectionView.contentInset = UIEdgeInsetsMake(0, self.effectiveZeroOffset, 0,0);
    self.howLongCollectionView.contentInset = UIEdgeInsetsMake(0, self.effectiveZeroOffset, 0,0);
    
    [self scrollCollectionView:self.howLongCollectionView toIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] animated:NO];
    [self scrollCollectionView:self.howManyCollectionView toIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO];
    
//    CAGradientLayer *topGradeFade = [CAGradientLayer layer];
//    topGradeFade.anchorPoint = CGPointZero;
//    topGradeFade.frame = CGRectMake(self.howLongLabel.frame.size.width, 0, self.statsContainerView.frame.size.width-self.howLongLabel.frame.size.width, self.statsContainerView.frame.size.height);
//    topGradeFade.startPoint =  CGPointMake(0, 0.5);
//    topGradeFade.endPoint =  CGPointMake(1, 0.5);
//    topGradeFade.locations = @[@0,@0.4,@0.6,@1];
//    topGradeFade.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor];
//    self.statsContainerView.layer.mask = topGradeFade;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.hasScrolledCollectionViews) {
        [self setLayoutConstants];
    }
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.backgroundBlurView toExtentOfParent:self.view];
    [NSLayoutConstraint extentOfChild:self.scrollContainer toExtentOfParent:self.view];
    
    [NSLayoutConstraint view:self.gameTimeLabel toFixedHeight:kHeaderLabelHeight];
    [NSLayoutConstraint leftOfChild:self.gameTimeLabel toLeftOfParent:self.scrollableContentContainerView withFixedMargin:10];
    [NSLayoutConstraint topOfChild:self.gameTimeLabel toTopOfParent:self.scrollableContentContainerView];
    
    [NSLayoutConstraint sidesOfChild:self.timePicker toSidesOfParent:self.scrollableContentContainerView];
    [NSLayoutConstraint topOfChild:self.timePicker toBottomOfSibling:self.gameTimeLabel withFixedMargin:0 inParent:self.scrollableContentContainerView];
    
    [NSLayoutConstraint topOfChild:self.statsLabel toBottomOfSibling:self.timePicker withFixedMargin:0 inParent:self.scrollableContentContainerView];
    [NSLayoutConstraint leftOfChild:self.statsLabel toLeftOfParent:self.scrollableContentContainerView withFixedMargin:10];
    [NSLayoutConstraint view:self.statsLabel toFixedHeight:kHeaderLabelHeight];
    
    [NSLayoutConstraint topOfChild:self.statsContainerView toBottomOfSibling:self.statsLabel withFixedMargin:0 inParent:self.scrollableContentContainerView];
    [NSLayoutConstraint sidesOfChild:self.statsContainerView toSidesOfParent:self.scrollableContentContainerView];
    [NSLayoutConstraint view:self.statsContainerView toFixedHeight:kStatsContainerHeight];
    
    [NSLayoutConstraint view:self.howLongLabel toFixedWidth:kSideLabelWidth];
    [NSLayoutConstraint view:self.howLongLabel toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint topOfChild:self.howLongLabel toTopOfParent:self.statsContainerView];
    [NSLayoutConstraint leftOfChild:self.howLongLabel toLeftOfParent:self.statsContainerView withFixedMargin:0];
    
    [NSLayoutConstraint leftOfChild:self.howLongCollectionView toRightOfSibling:self.howLongLabel withFixedMargin:0 inParent:self.statsContainerView];
    [NSLayoutConstraint rightOfChild:self.howLongCollectionView toRightOfParent:self.statsContainerView withFixedMargin:0];////////////// WHY GIVING CONSTRAINT ISSUES
    [NSLayoutConstraint view:self.howLongCollectionView toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint topOfChild:self.howLongCollectionView toTopOfParent:self.statsContainerView];
    
    CGFloat lineWidth = 0.5;
    
    [NSLayoutConstraint leftOfChild:self.collectionViewDividerLine toLeftOfParent:self.statsContainerView withFixedMargin:10];
    [NSLayoutConstraint view:self.collectionViewDividerLine toFixedHeight:lineWidth];
    [NSLayoutConstraint rightOfChild:self.collectionViewDividerLine toRightOfParent:self.statsContainerView withFixedMargin:0];////////////// WHY GIVING CONSTRAINT ISSUES
    [NSLayoutConstraint topOfChild:self.collectionViewDividerLine toBottomOfSibling:self.howLongCollectionView withFixedMargin:0 inParent:self.statsContainerView];
    
    [NSLayoutConstraint view:self.howManyLabel toFixedWidth:kSideLabelWidth];
    [NSLayoutConstraint centerYOfChild:self.howManyLabel toCenterYOfSibling:self.howManyCollectionView inParent:self.statsContainerView];
    [NSLayoutConstraint leftOfChild:self.howManyLabel toLeftOfParent:self.statsContainerView withFixedMargin:0];
    
    [NSLayoutConstraint leftOfChild:self.howManyCollectionView toRightOfSibling:self.howManyLabel withFixedMargin:0 inParent:self.statsContainerView];
    [NSLayoutConstraint view:self.howManyCollectionView toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint rightOfChild:self.howManyCollectionView toRightOfParent:self.statsContainerView withFixedMargin:0]; ////////////// WHY GIVING CONSTRAINT ISSUES
    [NSLayoutConstraint topOfChild:self.howManyCollectionView toBottomOfSibling:self.collectionViewDividerLine withFixedMargin:0 inParent:self.statsContainerView];

    
    //lines
    [NSLayoutConstraint centerYOfChild:self.topLeftDividerLine toCenterYOfSibling:self.howLongCollectionView inParent:self.statsContainerView];
    [NSLayoutConstraint view:self.topLeftDividerLine toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint view:self.topLeftDividerLine toFixedWidth:lineWidth];
    [NSLayoutConstraint centerXOfChild:self.topLeftDividerLine toCenterXOfSibling:self.howLongCollectionView inParent:self.statsContainerView withMargin:-kCellItemWidth/2];
    
    [NSLayoutConstraint centerYOfChild:self.topRighttDividerLine toCenterYOfSibling:self.howLongCollectionView inParent:self.statsContainerView];
    [NSLayoutConstraint view:self.topRighttDividerLine toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint view:self.topRighttDividerLine toFixedWidth:lineWidth];
    [NSLayoutConstraint centerXOfChild:self.topRighttDividerLine toCenterXOfSibling:self.howLongCollectionView inParent:self.statsContainerView withMargin:kCellItemWidth/2];
    
    [NSLayoutConstraint centerYOfChild:self.bottomLeftDividerLine toCenterYOfSibling:self.howManyCollectionView inParent:self.statsContainerView];
    [NSLayoutConstraint view:self.bottomLeftDividerLine toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint view:self.bottomLeftDividerLine toFixedWidth:lineWidth];
    [NSLayoutConstraint centerXOfChild:self.bottomLeftDividerLine toCenterXOfSibling:self.howManyCollectionView inParent:self.statsContainerView withMargin:-kCellItemWidth/2];
    
    [NSLayoutConstraint centerYOfChild:self.bottomRightDividerLine toCenterYOfSibling:self.howManyCollectionView inParent:self.statsContainerView];
    [NSLayoutConstraint view:self.bottomRightDividerLine toFixedHeight:kStatsContainerHeight/2];
    [NSLayoutConstraint view:self.bottomRightDividerLine toFixedWidth:lineWidth];
    [NSLayoutConstraint centerXOfChild:self.bottomRightDividerLine toCenterXOfSibling:self.howManyCollectionView inParent:self.statsContainerView withMargin:kCellItemWidth/2];
    
    //summon bar
    [NSLayoutConstraint bottomOfChild:self.summonButtonContainer toBottomOfParent:self.view];
    [NSLayoutConstraint sidesOfChild:self.summonButtonContainer toSidesOfParent:self.view];
    [NSLayoutConstraint view:self.summonButtonContainer toFixedHeight:50];
    
    [NSLayoutConstraint extentOfChild:self.summonButton toExtentOfParent:self.summonButtonContainer.contentView];
    
    [NSLayoutConstraint centerYOfChild:self.summonImage toCenterYOfSibling:self.summonButtonContainer inParent:self.view];
    [NSLayoutConstraint rightOfChild:self.summonImage toRightOfSibling:self.summonButton withFixedMargin:-15 inParent:self.view];
}

- (void)summonButtonPressed {
    CGFloat jiggleDuration = 1.8;
    CGFloat animationDuration = 0.35;
    
    CABasicAnimation *jiggle = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    jiggle.duration = 0.1;
    jiggle.autoreverses = YES;
    jiggle.repeatDuration = jiggleDuration;
    jiggle.fromValue = [NSNumber numberWithDouble:M_PI/24];
    jiggle.toValue = [NSNumber numberWithDouble:-M_PI/24];
    [self.summonImage.layer addAnimation:jiggle forKey:@"someKey"];
    [UIView animateWithDuration:animationDuration animations:^{
        self.summonImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(10, 10), CGAffineTransformMakeTranslation(-120, -120));
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((jiggleDuration-2*animationDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:animationDuration animations:^{
                self.summonImage.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(dismissViewControllerDown)]) {
                    [self.delegate dismissViewControllerDown];
                }
            }];
        });
    }];
}

#pragma mark Sroll View Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = roundf(targetContentOffset->x/kCellItemWidth)*kCellItemWidth+8.5;
    self.hasScrolledCollectionViews = YES;
}

#pragma mark Collection View Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SBNumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    NSNumber *displayNumber;
    if ([collectionView isEqual:self.howLongCollectionView]) {
        displayNumber = [NSNumber numberWithFloat:indexPath.row*0.5+1];
    } else {
        displayNumber = [NSNumber numberWithInteger:indexPath.row+1];
    }
    
    cell.displayNumber = displayNumber;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollCollectionView:collectionView toIndexPath:indexPath animated:YES];
}

- (void)scrollCollectionView:(UICollectionView*)cv toIndexPath:(NSIndexPath*)idx animated:(BOOL)animated {
    [cv setContentOffset:CGPointMake(idx.row*kCellItemWidth-self.effectiveZeroOffset, 0) animated:animated];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
