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

@implementation SBGamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameTableView = [[UITableView alloc] init];
    self.gameTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gameTableView.delegate = self;
    self.gameTableView.dataSource = self;
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
//    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SBGameTableViewCell *cell = (SBGameTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SBGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.rightUtilityButtons = [self rightButtons];
//        cell.delegate = self;
    }
    
    Game *game = [Game MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    game.startTime = [NSDate dateWithTimeIntervalSinceNow:60*arc4random_uniform(3)];
    game.address = @"536 Waller St";
    game.userIdArray = [NSKeyedArchiver archivedDataWithRootObject:arc4random_uniform(2) == 1 ? @[@3,@4] : @[@1,@2,@3,@4]];
    [cell setupCellContentWithGame:game];
    
    return cell;
}

//- (NSArray *)rightButtons
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redDecline] title:@"Lame\nExcuse"];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor greenAccept] title:@"Rage"];
//    
//    return rightUtilityButtons;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSArray *)leftButtons
//{
//    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
//
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"check.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"clock.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"cross.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"list.png"]];
//
//    return leftUtilityButtons;
//}
@end
