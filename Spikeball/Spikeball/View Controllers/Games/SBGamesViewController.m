//
//  SBGamesViewController.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/22/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBGamesViewController.h"
//#import "SWTableViewCell+GameInfoSetup.h"
#import "SBGameTableViewCell.h"
#import "SBLibrary.h"

//TAKE ME OUT
#import <CoreData+MagicalRecord.h>

@interface SBGamesViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>//, SWTableViewCellDelegate>

@property (nonatomic,strong) UITableView *gameTableView;

@end

static NSInteger kHeaderHeight = 27;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"sdf");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
//    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SBGameTableViewCell *cell = (SBGameTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SBGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *allGames = [Game MR_findAll];
    while ([allGames count] <= indexPath.section) {
        Game *game = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        game.startTime = [NSDate dateWithTimeIntervalSinceNow:60*arc4random_uniform(3)];
        game.address = @"536 Waller St";
        game.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:indexPath.section%2 == 0 ? @[@3,@4] : @[@1,@2,@3,@4]];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        allGames = [Game MR_findAll];
    }
    
    Game *game = [allGames objectAtIndex:indexPath.section];
    [cell setupCellContentWithGame:game];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;//kHeaderHeight;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight)];
//    header.backgroundColor = [UIColor lightGrayGameCellsBackground];
//    
//    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
//    topSeparator.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
//    [header addSubview:topSeparator];
//    
//    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight-0.5, self.view.frame.size.width, 0.5)];
//    bottomSeparator.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
//    [header addSubview:bottomSeparator];
//    
//    return header;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
