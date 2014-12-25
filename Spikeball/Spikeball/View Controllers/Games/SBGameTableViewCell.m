//
//  SBGameTableViewCell.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/23/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBGameTableViewCell.h"
#import "SBLibrary.h"
#import "SBUser+SBUserHelper.h"

@interface SBGameTableViewCell () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollViewContainer;
@property (nonatomic,strong) UIButton *closeScrollButton;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *gameNamesLabel;
@property (nonatomic, strong) UILabel *startsWhenLabel;
@property (nonatomic, strong) UILabel *distanceAddressLabel;
@property (nonatomic, strong) UIImageView *creatorImageView;
@property (nonatomic, strong) UIView *responseStatusVerticalBar;

@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *declineButton;

@end

static NSInteger kAccessoryButtonWidth = 65;
static NSInteger imageToLabelBuffer = 38;// image to label buffer
static NSInteger imageToEdgeBuffer = 7;
static NSInteger labelToResponseBarBuffer = 15;
static NSInteger labelSeparationBuffer = 5;

@implementation SBGameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSwipeBegan:) name:SBNotificationGameCellSwipeBeganWithCell object:nil];
        
        self.scrollViewContainer = [[UIScrollView alloc] init];
        self.scrollViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollViewContainer.showsHorizontalScrollIndicator = NO;
        self.scrollViewContainer.delegate = self;
        [self.contentView addSubview:self.scrollViewContainer];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.userInteractionEnabled = NO;
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.scrollViewContainer addSubview:self.containerView];
        
        self.closeScrollButton = [[UIButton alloc] init];
        self.closeScrollButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.closeScrollButton.backgroundColor = [UIColor clearColor];
        self.closeScrollButton.enabled = NO;
        [self.closeScrollButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewContainer addSubview:self.closeScrollButton];
        
        NSInteger gameNameFontSize = 15;
        self.gameNamesLabel = [[UILabel alloc] init];
        self.gameNamesLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.gameNamesLabel.textAlignment = NSTextAlignmentRight;
        self.gameNamesLabel.font = [UIFont fontWithName:SBFontStandard size:gameNameFontSize];
        self.gameNamesLabel.textColor = [UIColor blackColor];
        [self.containerView addSubview:self.gameNamesLabel];
        
        self.startsWhenLabel = [[UILabel alloc] init];
        self.startsWhenLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.startsWhenLabel.textAlignment = NSTextAlignmentRight;
        self.startsWhenLabel.font = [UIFont fontWithName:SBFontStandard size:gameNameFontSize-1];
        [self.containerView addSubview:self.startsWhenLabel];
        
        self.distanceAddressLabel = [[UILabel alloc] init];
        self.distanceAddressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.distanceAddressLabel.textAlignment = NSTextAlignmentRight;
        self.distanceAddressLabel.font = [UIFont fontWithName:SBFontStandard size:gameNameFontSize-2];
        [self.containerView addSubview:self.distanceAddressLabel];
        
        self.creatorImageView = [[UIImageView alloc] init];
        self.creatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.creatorImageView.layer.masksToBounds = YES;
        self.creatorImageView.layer.cornerRadius = (kCellHeight-2*imageToEdgeBuffer)/2;
        self.creatorImageView.layer.borderColor = [[UIColor spikeballBlack] colorWithAlphaComponent:0.6].CGColor;
        self.creatorImageView.layer.borderWidth = 0.5;
        [self.containerView addSubview:self.creatorImageView];
        
        self.responseStatusVerticalBar = [[UIView alloc] init];
        self.responseStatusVerticalBar.translatesAutoresizingMaskIntoConstraints = NO;
        self.responseStatusVerticalBar.userInteractionEnabled = NO;
        [self.containerView addSubview:self.responseStatusVerticalBar];
        
        self.acceptButton = [[UIButton alloc] init];
        self.acceptButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.acceptButton.backgroundColor = [UIColor greenAccept];
        [self.acceptButton setTitle:@"Rage" forState:UIControlStateNormal];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.acceptButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
        self.acceptButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.acceptButton addTarget:self action:@selector(acceptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView insertSubview:self.acceptButton belowSubview:self.scrollViewContainer];
        [self.scrollViewContainer insertSubview:self.acceptButton belowSubview:self.containerView];
        
        self.declineButton = [[UIButton alloc] init];
        self.declineButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.declineButton.backgroundColor = [UIColor redDecline];
        [self.declineButton setTitle:@"Goldfish\nDied" forState:UIControlStateNormal];
        self.declineButton.titleLabel.numberOfLines = 2;
        [self.declineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.declineButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
        self.declineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.declineButton  addTarget:self action:@selector(declineButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView insertSubview:self.declineButton belowSubview:self.scrollViewContainer];
        [self.scrollViewContainer insertSubview:self.declineButton belowSubview:self.containerView];
        
        [self setCellStateForXOffset:self.scrollViewContainer.contentOffset.x];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.scrollViewContainer toExtentOfParent:self];
    [NSLayoutConstraint extentOfChild:self.closeScrollButton toExtentOfSibling:self.containerView inParent:self.scrollViewContainer];
    
    [NSLayoutConstraint rightOfChild:self.gameNamesLabel toLeftOfSibling:self.responseStatusVerticalBar withFixedMargin:-labelToResponseBarBuffer inParent:self.containerView];
    [NSLayoutConstraint leftOfChild:self.gameNamesLabel toRightOfSibling:self.creatorImageView withFixedMargin:imageToLabelBuffer inParent:self.containerView];
    [NSLayoutConstraint bottomOfChild:self.gameNamesLabel toTopOfSibling:self.startsWhenLabel withFixedMargin:-labelSeparationBuffer inParent:self.containerView];
    
    [NSLayoutConstraint centerYOfChild:self.startsWhenLabel toCenterYOfParent:self.containerView];
    [NSLayoutConstraint rightOfChild:self.startsWhenLabel toLeftOfSibling:self.responseStatusVerticalBar withFixedMargin:-labelToResponseBarBuffer inParent:self.containerView];
    [NSLayoutConstraint leftOfChild:self.startsWhenLabel toRightOfSibling:self.creatorImageView withFixedMargin:imageToLabelBuffer inParent:self.containerView];
    
    [NSLayoutConstraint rightOfChild:self.distanceAddressLabel toLeftOfSibling:self.responseStatusVerticalBar withFixedMargin:-labelToResponseBarBuffer inParent:self.containerView];
    [NSLayoutConstraint leftOfChild:self.distanceAddressLabel toRightOfSibling:self.creatorImageView withFixedMargin:imageToLabelBuffer inParent:self.containerView];
    [NSLayoutConstraint topOfChild:self.distanceAddressLabel toBottomOfSibling:self.startsWhenLabel withFixedMargin:labelSeparationBuffer inParent:self.containerView];
    
    [NSLayoutConstraint view:self.creatorImageView toFixedHeight:kCellHeight-2*imageToEdgeBuffer];
    [NSLayoutConstraint view:self.creatorImageView toFixedWidth:kCellHeight-2*imageToEdgeBuffer];
    [NSLayoutConstraint centerYOfChild:self.creatorImageView toCenterYOfParent:self.containerView];
    [NSLayoutConstraint leftOfChild:self.creatorImageView toLeftOfParent:self.containerView withFixedMargin:imageToEdgeBuffer];
    
    [NSLayoutConstraint topOfChild:self.responseStatusVerticalBar toTopOfParent:self.containerView];
    [NSLayoutConstraint bottomOfChild:self.responseStatusVerticalBar toBottomOfParent:self.containerView];
    [NSLayoutConstraint rightOfChild:self.responseStatusVerticalBar toRightOfParent:self.containerView withFixedMargin:0];
    [NSLayoutConstraint view:self.responseStatusVerticalBar toFixedWidth:5];
    
    [NSLayoutConstraint topOfChild:self.acceptButton toTopOfParent:self.contentView];
    [NSLayoutConstraint bottomOfChild:self.acceptButton toBottomOfParent:self.contentView];
    [NSLayoutConstraint rightOfChild:self.acceptButton toRightOfParent:self.contentView withFixedMargin:0];
    [NSLayoutConstraint view:self.acceptButton toFixedWidth:kAccessoryButtonWidth];

    [NSLayoutConstraint topOfChild:self.declineButton toTopOfParent:self.contentView];
    [NSLayoutConstraint bottomOfChild:self.declineButton toBottomOfParent:self.contentView];
    [NSLayoutConstraint rightOfChild:self.declineButton toLeftOfSibling:self.acceptButton withFixedMargin:0 inParent:self.contentView];
    [NSLayoutConstraint view:self.declineButton toFixedWidth:kAccessoryButtonWidth];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollViewContainer.contentSize = CGSizeMake(self.frame.size.width+2*kAccessoryButtonWidth, self.frame.size.height);
}

- (void)setupCellContentWithGame:(Game*)game {
    self.gameNamesLabel.text = @"Sarah, John & Mike";
    self.startsWhenLabel.text = @"Starts in 10 min!";
    self.startsWhenLabel.textColor = [UIColor greenAccept];
    self.distanceAddressLabel.text = @"10 mi away - 536 Waller St";
    NSArray *gameUserIdArray = [NSKeyedUnarchiver unarchiveObjectWithData:game.userIdArray];
    SBUser *user = [SBUser currentUser];
    self.creatorImageView.image = [gameUserIdArray containsObject:user.userId] ? [UIImage imageNamed:@"_0000_Layer-1"] : [UIImage imageNamed:@"_0001_Layer-2"];
    self.responseStatusVerticalBar.backgroundColor = [gameUserIdArray containsObject:user.userId] ? [UIColor greenAccept] : [UIColor redDecline];
}

- (void)cellSwipeBegan:(NSNotification*)note {
    SBGameTableViewCell *cell = note.object;
    if (![cell isEqual:self]) {
        [self closeScrollView];
    }
}

- (void)closeScrollView {
    NSLog(@"CLOSE scroll");
    [self.scrollViewContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark Button Handlers
- (void)acceptButtonPressed {
    NSLog(@"ACCEPT");
    [self closeScrollView];
}

- (void)declineButtonPressed {
    NSLog(@"DECLINE");
    [self closeScrollView];
}

- (void)setCellStateForXOffset:(CGFloat)offset {
    if (offset == 0) {
        self.closeScrollButton.enabled = NO;
        self.acceptButton.enabled = self.declineButton.enabled = NO;
    } else {
        self.closeScrollButton.enabled = YES;
        self.acceptButton.enabled = self.declineButton.enabled = YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.responseStatusVerticalBar.alpha = offset == 0;
    }];
}

#pragma mark Scroll View Delegate Methods
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setCellStateForXOffset:scrollView.contentOffset.x];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.x < 0 || (velocity.x == 0 && scrollView.contentOffset.x < kAccessoryButtonWidth)) {
        targetContentOffset->x = 0;
    } else {
        targetContentOffset->x = 2*kAccessoryButtonWidth;
    }
    [self setCellStateForXOffset:targetContentOffset->x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationGameCellSwipeBeganWithCell object:self];
    
    self.responseStatusVerticalBar.alpha = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"DID");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.scrollViewContainer.contentOffset = CGPointZero;
    self.responseStatusVerticalBar.alpha = 1;
}

@end
