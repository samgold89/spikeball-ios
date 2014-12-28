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
#import <CoreData+MagicalRecord.h>
#import "AppDelegate.h"
#import "SBMapWithGameViewController.h"
#import "SBPlayerImageCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SBGameTableViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *mapTopBorder;
@property (nonatomic, strong) SBMapWithGameViewController *mapGameViewController;
@property (nonatomic, strong) SBPlayerImageCollectionViewController *playerHeadCollectionView;

@property (nonatomic, assign) BOOL anotherCellIsExpanded;
@property (nonatomic, assign) BOOL updateCellAfterAnimation;

@property (nonatomic, strong) UIScrollView *scrollViewContainer;
@property (nonatomic, strong) UIButton *closeScrollOrShowGameButton;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *gameNamesLabel;
@property (nonatomic, strong) UILabel *startsWhenLabel;
@property (nonatomic, strong) UILabel *distanceAddressLabel;
@property (nonatomic, strong) UIImageView *creatorImageView;
@property (nonatomic, strong) UIView *responseStatusVerticalBar;
@property (nonatomic, strong) NSArray *collectionViewConstraints;

@property (nonatomic, strong) NSLayoutConstraint *acceptButtonWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *declineButtonWidthConstraint;
//@property (nonatomic, strong) NSLayoutConstraint *cancelButtonWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *collapsedCellConstraint;
@property (nonatomic, strong) NSLayoutConstraint *responseStatusVerticalBarRightConstraint;

@property (nonatomic, strong) NSArray *accessoryButtons;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *declineButton;
//@property (nonatomic, strong) UIButton *cancelGameButton;

@end

static NSInteger kAccessoryButtonWidth = 68;
static NSInteger imageToLabelBuffer = 38;// image to label buffer
static NSInteger imageToEdgeBuffer = 7;
static NSInteger labelToResponseBarBuffer = 15;
static NSInteger labelSeparationBuffer = 5;
static NSInteger kMapExpandedSize = 183;

@implementation SBGameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSwipeBegan:) name:SBNotificationGameCellSwipeBeganWithCell object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDistanceLabelBasedOnLocation:) name:SBNotificationUserLocationUpdated object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellIsExpandingNotification:) name:SBNotificationGameCellExpanding object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allCellsAreCollapsed:) name:SBNotificationGameCellAllAreCollapsing object:nil];
        
        self.scrollViewContainer = [[UIScrollView alloc] init];
        self.scrollViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollViewContainer.showsHorizontalScrollIndicator = NO;
        self.scrollViewContainer.delegate = self;
        [self.contentView addSubview:self.scrollViewContainer];
        
        //clever little hack to still allow cells to be selected
//        [self.scrollViewContainer setUserInteractionEnabled:NO];
//        [self.contentView addGestureRecognizer:self.scrollViewContainer.panGestureRecognizer];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.userInteractionEnabled = NO;
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.scrollViewContainer addSubview:self.containerView];
        
        self.closeScrollOrShowGameButton = [[UIButton alloc] init];
        self.closeScrollOrShowGameButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.closeScrollOrShowGameButton.backgroundColor = [UIColor clearColor];
        [self.closeScrollOrShowGameButton addTarget:self action:@selector(closeScrollOrShowGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewContainer addSubview:self.closeScrollOrShowGameButton];
        
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
        [self.acceptButton setTitle:@"I'm in!" forState:UIControlStateNormal];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.acceptButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
        self.acceptButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.acceptButton addTarget:self action:@selector(acceptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.acceptButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [self.scrollViewContainer insertSubview:self.acceptButton belowSubview:self.containerView];
        
        self.declineButton = [[UIButton alloc] init];
        self.declineButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.declineButton.backgroundColor = [UIColor redDecline];
        [self.declineButton setTitle:@"Next Time" forState:UIControlStateNormal];
        self.declineButton.titleLabel.numberOfLines = 2;
        [self.declineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.declineButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
        self.declineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.declineButton  addTarget:self action:@selector(declineButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.declineButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [self.scrollViewContainer insertSubview:self.declineButton belowSubview:self.containerView];
        
//        self.cancelGameButton = [[UIButton alloc] init];
//        self.cancelGameButton.translatesAutoresizingMaskIntoConstraints = NO;
//        self.cancelGameButton.backgroundColor = [UIColor redDecline];
//        [self.cancelGameButton setTitle:@"Cancel Game" forState:UIControlStateNormal];
//        [self.cancelGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.cancelGameButton.titleLabel.font = [UIFont fontWithName:SBFontStandard size:14];
//        self.cancelGameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.cancelGameButton addTarget:self action:@selector(cancenGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        self.cancelGameButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
//        [self.scrollViewContainer insertSubview:self.cancelGameButton belowSubview:self.containerView];
        
        //all cells will have a map that first has 0 height
        self.mapGameViewController = [[SBMapWithGameViewController alloc] init];
        self.mapGameViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.mapGameViewController.view];
        
        self.mapTopBorder = [[UIView alloc] init];
        self.mapTopBorder.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.mapTopBorder.alpha = 0;
        self.mapTopBorder.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.mapTopBorder];
        
        [self setCellStateForXOffset:self.scrollViewContainer.contentOffset.x];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    [NSLayoutConstraint view:self.scrollViewContainer toFixedHeight:kCellHeight];
    [NSLayoutConstraint sidesOfChild:self.scrollViewContainer toSidesOfParent:self.contentView];
    [NSLayoutConstraint topOfChild:self.scrollViewContainer toTopOfParent:self.contentView];
    
    [NSLayoutConstraint extentOfChild:self.closeScrollOrShowGameButton toExtentOfSibling:self.containerView inParent:self.scrollViewContainer];
    
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
    self.responseStatusVerticalBarRightConstraint = [NSLayoutConstraint rightOfChild:self.responseStatusVerticalBar toRightOfParent:self.containerView withFixedMargin:0];
    [NSLayoutConstraint view:self.responseStatusVerticalBar toFixedWidth:5];
    
    [NSLayoutConstraint topOfChild:self.acceptButton toTopOfParent:self.contentView];
    [NSLayoutConstraint view:self.acceptButton toFixedHeight:kCellHeight];
    [NSLayoutConstraint rightOfChild:self.acceptButton toRightOfParent:self.contentView withFixedMargin:0];
    self.acceptButtonWidthConstraint =[NSLayoutConstraint view:self.acceptButton toFixedWidth:0]; //start at 0 - expanded during scrollview scroll

    [NSLayoutConstraint topOfChild:self.declineButton toTopOfParent:self.contentView];
    [NSLayoutConstraint view:self.declineButton toFixedHeight:kCellHeight];
    [NSLayoutConstraint rightOfChild:self.declineButton toLeftOfSibling:self.acceptButton withFixedMargin:0 inParent:self.contentView];
    self.declineButtonWidthConstraint = [NSLayoutConstraint view:self.declineButton toFixedWidth:0]; //start at 0 - expanded during scrollview scroll
    
//    [NSLayoutConstraint topOfChild:self.cancelGameButton toTopOfParent:self.contentView];
//    [NSLayoutConstraint view:self.cancelGameButton toFixedHeight:kCellHeight];
//    [NSLayoutConstraint rightOfChild:self.cancelGameButton toRightOfParent:self.contentView withFixedMargin:0];
//    self.cancelButtonWidthConstraint = [NSLayoutConstraint view:self.cancelGameButton toFixedWidth:0]; //start at 0 - expanded during scrollview scroll
    
    [NSLayoutConstraint topOfChild:self.mapTopBorder toTopOfSibling:self.mapGameViewController.view withFixedMargin:0 inParent:self.contentView];
    [NSLayoutConstraint view:self.mapTopBorder toFixedHeight:0.5];
    [NSLayoutConstraint sidesOfChild:self.mapTopBorder toSidesOfParent:self.contentView];
    
    self.collapsedCellConstraint = [NSLayoutConstraint view:self.mapGameViewController.view toFixedHeight:0];
    [NSLayoutConstraint sidesOfChild:self.mapGameViewController.view toSidesOfParent:self.contentView];
    [NSLayoutConstraint topOfChild:self.mapGameViewController.view toBottomOfSibling:self.scrollViewContainer withFixedMargin:0 inParent:self.contentView];
    [NSLayoutConstraint bottomOfChild:self.mapGameViewController.view toBottomOfParent:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, kCellHeight);
    self.scrollViewContainer.contentSize = CGSizeMake(self.frame.size.width+self.accessoryButtons.count*kAccessoryButtonWidth, self.scrollViewContainer.frame.size.height-.5); //sometimes off by .5...just to make sure
}

- (SBCellSlideState)cellSlideState {
    if (self.scrollViewContainer.contentOffset.x == 0) {
        return SBCellSlieStateClosed;
    } else {
        return SBCellSlieStateOpened;
    }
}

#pragma mark Content Setup
- (void)setupCellContentWithGame:(Game*)game setOtherCellIsExpanded:(BOOL)otherCellIsEpanded {
    self.anotherCellIsExpanded = otherCellIsEpanded;
    
    self.game = game;
    self.startsWhenLabel.text = @"Starts in 10 min!";
    self.startsWhenLabel.textColor = [UIColor greenAccept];
    
    //get location and distance
    [self setDistanceLabelBasedOnLocation:nil];
    //set map now that we have coordinates
    self.mapGameViewController.latLongGameLocation = CLLocationCoordinate2DMake([self.game.locationLat floatValue], [self.game.locationLong floatValue]);
    
    NSArray *gameUserIdArray = [NSKeyedUnarchiver unarchiveObjectWithData:game.userIdArray];
    NSMutableArray *namesArray = [@[] mutableCopy];
    NSMutableArray *allUsers = [@[] mutableCopy];
    for (NSNumber *userId in gameUserIdArray) {
        SBUser *user = [SBUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(%K=%@)",@"userId",userId]];
        NSAssert(user, @"USER SHOULD NOT BE NIL WHEN SHOWING PLAYER SCROLLER FOR GAME");
        [allUsers addObject:user];
        [namesArray addObject:user.nickName ?: user.firstName ?: user.lastName?: @"JohnnyDoe"];
    }
    if ([namesArray count] == 1) {
        self.gameNamesLabel.text = [NSString stringWithFormat:@"%@",[namesArray objectAtIndex:0]];
    } else if ([namesArray count] == 2) {
        self.gameNamesLabel.text = [NSString stringWithFormat:@"%@ & %@",[namesArray objectAtIndex:0],[namesArray objectAtIndex:1]];
    } else if ([namesArray count] == 3) {
        self.gameNamesLabel.text = [NSString stringWithFormat:@"%@, %@ & %@",[namesArray objectAtIndex:0],[namesArray objectAtIndex:1],[namesArray objectAtIndex:2]];
    } else {
        self.gameNamesLabel.text = [NSString stringWithFormat:@"%@, %@ & %lu more",[namesArray objectAtIndex:0],[namesArray objectAtIndex:1],[namesArray count]-2];
    }
    
    SBUser *creator = [SBUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(%K=%@)",@"userId",self.game.creatorId]];
    if ([creator isEqual:[SBUser currentUser]]) {
        self.accessoryButtons = @[];
        self.acceptButton.alpha = self.declineButton.alpha = 0;
//        self.cancelGameButton.alpha = 1;
    } else {
        self.accessoryButtons = @[self.declineButton,self.acceptButton];
//        self.cancelGameButton.alpha = 0;
        self.acceptButton.alpha = self.declineButton.alpha = 1;
    }
    [self.creatorImageView sd_setImageWithURL:[NSURL URLWithString:creator.imageUrl] placeholderImage:[UIImage imageNamed:SBDefaultPlayerImageName]];
    self.responseStatusVerticalBar.backgroundColor = [self.game.creatorId isEqualToNumber:[SBUser currentUser].userId] ? [UIColor spikeballYellow] : [gameUserIdArray containsObject:[SBUser currentUser].userId] ? [UIColor greenAccept] : [UIColor redDecline];
}

- (void)setDistanceLabelBasedOnLocation:(NSNotification*)note {
    NSString *locationString = @"";
    CLLocation *userLocation;
    
    if (note) {
        userLocation = note.object;
    } else {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        userLocation = appDelegate.lastUserLocation;
    }
    
    if (userLocation) {
        CLLocation *gameLocation = [[CLLocation alloc] initWithLatitude:[self.game.locationLat floatValue] longitude:[self.game.locationLong floatValue]];
        CLLocationDistance distanceInMeters = [gameLocation distanceFromLocation:userLocation];
        CGFloat milesRounded = distanceInMeters/1609.34; //1609 meters to mile
        locationString = [NSString stringWithFormat:@"%.1f mi away - ",milesRounded];
    }
    self.distanceAddressLabel.text = [NSString stringWithFormat:@"%@%@",locationString,self.game.address];
}

- (void)closeScrollView {
    [self.scrollViewContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)setCellStateForXOffset:(CGFloat)offset {
    if (offset == 0) {
        self.acceptButton.enabled = self.declineButton.enabled = /*self.cancelGameButton.enabled =*/ NO;
    } else {
        self.acceptButton.enabled = self.declineButton.enabled = /*self.cancelGameButton.enabled =*/ YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.responseStatusVerticalBar.alpha = offset == 0;
    }];
}

- (void)cellSwipeBegan:(NSNotification*)note {
    SBGameTableViewCell *cell = note.object;
    if (![cell isEqual:self]) {
        [self closeScrollView];
    }
}

#pragma mark Cell Expansion Mode
- (void)cellIsExpandingNotification:(NSNotification*)note {
    self.anotherCellIsExpanded = ![self isEqual:note.object];
}

- (void)allCellsAreCollapsed:(NSNotification*)note {
    self.anotherCellIsExpanded = NO;
}

- (void)setAnotherCellIsExpanded:(BOOL)anotherCellIsExpanded {
    _anotherCellIsExpanded = anotherCellIsExpanded;
    if (_anotherCellIsExpanded) {
        [self collapseCellFromExpandedAnimated:YES];
        self.scrollViewContainer.alpha = 0.4;
        self.scrollViewContainer.scrollEnabled = NO;
    } else {
        self.scrollViewContainer.alpha = 1;
        self.scrollViewContainer.scrollEnabled = YES;
    }
}

- (void)setCellExpandedModeAnimated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationGameCellExpanding object:self];
    
    self.scrollViewContainer.scrollEnabled = NO;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.lastUserLocation) {
        [self.mapGameViewController setMapViewZoomForGameWithLocation:appDelegate.lastUserLocation animated:NO];
    }
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mapTopBorder.alpha = 1;
        self.collapsedCellConstraint.constant = kMapExpandedSize;
    } completion:^(BOOL finished) {
        [self setupAllPlayersFacesAndAnimate:YES];
    }];
}

- (void)collapseCellFromExpandedAnimated:(BOOL)animated {
    if (self.collectionViewConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.collectionViewConstraints];
        self.collectionViewConstraints = nil;
    }
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.playerHeadCollectionView.view.center = CGPointMake(self.playerHeadCollectionView.view.center.x-self.frame.size.width, self.playerHeadCollectionView.view.center.y);
        self.creatorImageView.alpha = 1;
        
        self.mapTopBorder.alpha = 0;
        self.gameNamesLabel.alpha = self.startsWhenLabel.alpha = self.distanceAddressLabel.alpha = 1;
        self.collapsedCellConstraint.constant = 0;
        self.responseStatusVerticalBarRightConstraint.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {        
        [self.playerHeadCollectionView.view removeFromSuperview];
        self.playerHeadCollectionView = nil;
    }];
}

#pragma mark Bubble Head Setup
- (void)setupAllPlayersFacesAndAnimate:(BOOL)animate {
    self.playerHeadCollectionView = [[SBPlayerImageCollectionViewController alloc] init];
    self.playerHeadCollectionView.playerIdArray = [NSKeyedUnarchiver unarchiveObjectWithData:self.game.userIdArray];
    self.playerHeadCollectionView.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerHeadCollectionView.view.alpha = 0;
    [self.contentView addSubview:self.playerHeadCollectionView.view];
    self.collectionViewConstraints = [NSLayoutConstraint extentOfChild:self.playerHeadCollectionView.view toExtentOfSibling:self.scrollViewContainer inParent:self.contentView];
    [self layoutIfNeeded];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeScrollOrShowGameButtonPressed)];
    [self.playerHeadCollectionView.view addGestureRecognizer:tap];
    
    [UIView animateWithDuration:animate ? 0.35 : 0 animations:^{
        self.creatorImageView.alpha = 0;
        
        self.gameNamesLabel.alpha = self.startsWhenLabel.alpha = self.distanceAddressLabel.alpha = 0;
        
        self.responseStatusVerticalBarRightConstraint.constant = self.frame.size.width;
        [self layoutIfNeeded];
    }];
    
    NSArray *allCells = [self.playerHeadCollectionView allVisibleCellsOrderedByX];
    for (UIView *cell in allCells) {
        cell.center = CGPointMake(cell.center.x+self.frame.size.width, cell.center.y);
    }
    self.playerHeadCollectionView.view.alpha = 1;
    CGFloat counter = 0;
    for (UIView *cell in allCells) {
        [UIView animateWithDuration:0.7 delay:0.1*counter+0.05 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.center = CGPointMake(cell.center.x-self.frame.size.width, cell.center.y);
        } completion:nil];
        counter += 1;
    }
}

#pragma mark Button Handlers
- (void)acceptButtonPressed {
    NSMutableArray *userIdArray = [[NSKeyedUnarchiver unarchiveObjectWithData:self.game.userIdArray] mutableCopy];
    if (![userIdArray containsObject:[SBUser currentUser].userId]) {
        [userIdArray addObject:[SBUser currentUser].userId];
        //TODO: api call to update user
    }
    self.game.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:userIdArray];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    self.responseStatusVerticalBar.backgroundColor = [UIColor greenAccept];
    
    self.updateCellAfterAnimation = YES;
    [self closeScrollView];
}

- (void)declineButtonPressed {
    NSMutableArray *userIdArray = [[NSKeyedUnarchiver unarchiveObjectWithData:self.game.userIdArray] mutableCopy];
    if ([userIdArray containsObject:[SBUser currentUser].userId]) {
        [userIdArray removeObject:[SBUser currentUser].userId];
        //TODO: api call to update user
    }
    self.game.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:userIdArray];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    self.responseStatusVerticalBar.backgroundColor = [UIColor redDecline];
    
    self.updateCellAfterAnimation = YES;
    [self closeScrollView];
}

- (void)cancenGameButtonPressed {
    
}

- (void)closeScrollOrShowGameButtonPressed {
    switch (self.cellSlideState) {
        case SBCellSlieStateOpened:
            [self closeScrollView];
            break;
        case SBCellSlieStateClosed:
        default:
            if ([self.delegate respondsToSelector:@selector(cellTouchedShowGameForCell:)]) {
                [self.delegate cellTouchedShowGameForCell:self];
            }
            break;
    }
}

#pragma mark Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentOpened = scrollView.contentOffset.x/(self.accessoryButtons.count*kAccessoryButtonWidth);
    if (percentOpened < 0) {
        percentOpened = 0;
    }
    self.declineButtonWidthConstraint.constant = self.acceptButtonWidthConstraint.constant = /*self.cancelButtonWidthConstraint.constant = */kAccessoryButtonWidth*percentOpened;
    [self layoutIfNeeded];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setCellStateForXOffset:scrollView.contentOffset.x];
    if (self.updateCellAfterAnimation) {
        if ([self.delegate respondsToSelector:@selector(updateCell:)]) {
            [self.delegate updateCell:self];
        }
        self.updateCellAfterAnimation = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.x < 0 || (velocity.x == 0 && scrollView.contentOffset.x < kAccessoryButtonWidth)) {
        targetContentOffset->x = 0;
    } else {
        targetContentOffset->x = self.accessoryButtons.count*kAccessoryButtonWidth;
    }
    [self setCellStateForXOffset:targetContentOffset->x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationGameCellSwipeBeganWithCell object:self];
    self.responseStatusVerticalBar.alpha = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    self.scrollViewContainer.contentOffset = CGPointZero;
    self.responseStatusVerticalBar.alpha = 1;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
