//
//  SBGamesViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBGamesViewController.h"
//#import "SBMapWithGameViewController.h"
#import "SBGameTableViewCell.h"
#import "SBLibrary.h"

//TAKE ME OUT
#import <CoreData+MagicalRecord.h>

@interface SBGamesViewController () <UITableViewDataSource, UITableViewDelegate, SBGameTableViewCellDelegate>

@property (nonatomic,strong) UITableView *gameTableView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

static NSInteger kNumberOfCells = 8;

@implementation SBGamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayGameCellsBackground];
    
    self.gameTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.gameTableView.backgroundColor = [UIColor lightGrayGameCellsBackground];
    self.gameTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gameTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.gameTableView.delegate = self;
    self.gameTableView.dataSource = self;
    self.gameTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.gameTableView];
    [NSLayoutConstraint extentOfChild:self.gameTableView toExtentOfParent:self.view];
}

#pragma mark SBGameCell Delegate
- (void)cellTouchedShowGameForCell:(SBGameTableViewCell*)cell {
    NSIndexPath *path = [self.gameTableView indexPathForCell:cell];
    if ([self.selectedIndexPath isEqual:path]) {
        self.selectedIndexPath = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:SBNotificationGameCellAllAreCollapsing object:self];
    } else {
        self.selectedIndexPath = path;
    }
    
    if ([self.selectedIndexPath isEqual:path]) {
        [cell setCellExpandedModeAnimated:YES];
    } else {
        [cell collapseCellFromExpandedAnimated:YES];
    }
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.gameTableView beginUpdates];
        [self.gameTableView endUpdates];
        if (self.selectedIndexPath) {
            [self.gameTableView scrollToRowAtIndexPath:[self.gameTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    } completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"navTop = %lu",self.navigationController.tabBarController.selectedIndex);
    NSLog(@"me = %@",self.navigationController.tabBarController.selectedViewController);
    if ([self.navigationController.tabBarController.selectedViewController isEqual:self.navigationController]) {
        [self.tabBarController.tabBar setHidden:UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])]; //hide during landscape
    }
}

#pragma mark Tableview Delegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.selectedIndexPath isEqual:indexPath] ? kCellSelectedHeight : kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  kNumberOfCells;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    SBGameTableViewCell *cell = (SBGameTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SBGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *allGames = [Game MR_findAll];
    
    cell.delegate = self;
    Game *game = [allGames objectAtIndex:indexPath.section];
    [cell setupCellContentWithGame:game setOtherCellIsExpanded:self.selectedIndexPath && ![self.selectedIndexPath isEqual:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;//kHeaderHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
