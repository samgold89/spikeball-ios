//
//  SBGamesViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBGamesViewController.h"
#import "SBMapWithGameViewController.h"
#import "SBGameTableViewCell.h"
#import "SBLibrary.h"

//TAKE ME OUT
#import <CoreData+MagicalRecord.h>

@interface SBGamesViewController () <UITableViewDataSource, UITableViewDelegate, SBGameTableViewCellDelegate>

@property (nonatomic,strong) UITableView *gameTableView;

@end

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
    SBMapWithGameViewController *mapGameViewController = [[SBMapWithGameViewController alloc] init];
    mapGameViewController.latLongGameLocation = CLLocationCoordinate2DMake([cell.game.locationLat floatValue], [cell.game.locationLong floatValue]);
    [self.navigationController pushViewController:mapGameViewController animated:YES];
}

#pragma mark Tableview Delegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    SBGameTableViewCell *cell = (SBGameTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    return cell.cellSlideState == SBCellSlieStateClosed;
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
    [cell setupCellContentWithGame:game];
    
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
