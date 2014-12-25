//
//  SBPlayerImageCollectionViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBPlayerImageCollectionViewController.h"
#import "SBUser+SBUserHelper.h"
#import <CoreData+MagicalRecord.h>
#import "SBLibrary.h"

@interface SBPlayerImageCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *userArray;
@property (nonatomic,strong) UICollectionView *playerCollectionView;
@end

@implementation SBPlayerImageCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.userArray = [@[] mutableCopy];
    for (NSNumber *playerId in self.playerIdArray) {
        SBUser *user = [SBUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(%K=%@)",@"userId",playerId]];
        NSAssert(user, @"USER SHOULD NOT BE NIL WHEN SHOWING PLAYER SCROLLER FOR GAME");
        [self.userArray addObject:user];
    }
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(kPlayerCellHeight, kPlayerCellHeight);
    flow.minimumInteritemSpacing = 0;
    
    self.playerCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    self.playerCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerCollectionView.showsHorizontalScrollIndicator = NO;
    self.playerCollectionView.backgroundColor = [UIColor clearColor];
    self.playerCollectionView.delegate = self;
    self.playerCollectionView.dataSource = self;
    [self.view addSubview:self.playerCollectionView];
    
    // Register cell classes
    [self.playerCollectionView registerClass:[SBPlayerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupConstraints];
}

- (NSArray*)allVisibleCellsOrderedByX {
    NSMutableArray *currentVisibleCells = [[self.playerCollectionView visibleCells] mutableCopy];
    
    NSComparator comparatorBlock = ^(UIView *obj1, UIView *obj2) {
        if (obj1.frame.origin.x > obj2.frame.origin.x) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.frame.origin.x < obj2.frame.origin.x) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    [currentVisibleCells sortUsingComparator:comparatorBlock];
    return currentVisibleCells;
}

- (void)setupConstraints {
    [NSLayoutConstraint extentOfChild:self.playerCollectionView toExtentOfParent:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.userArray count];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SBPlayerCollectionViewCell *cell = (SBPlayerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [cell configureCellWithUser:[self.userArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
