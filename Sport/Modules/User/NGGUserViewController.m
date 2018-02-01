//
//  NGGUserViewController.m
//  sport
//
//  Created by Jan on 25/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGUserViewController.h"
#import "NGGNavigationController.h"
#import "NGGLoginViewController.h"
#import "NGGUserInfoViewController.h"
#import "NGGMessageViewController.h"
#import "NGGExchangeViewController.h"
#import "NGGRechargeViewController.h"
#import "NGGRegisterViewController.h"
#import "UIImageView+WebCache.h"
#import "NGGConsumptionDeatilViewController.h"
#import "NGGPrizeListViewController.h"
#import "NGGRecordViewController.h"

@interface NGGUserViewController ()<UITableViewDataSource, UITableViewDelegate> {
   
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UIView *_loginedHeader;
    __weak IBOutlet UIImageView *_loginedHeaderAvaterView;
    __weak IBOutlet UILabel *_loginedHeaderNameLabel;
    __weak IBOutlet UIButton *_loginedHeaderUserInfoButton;
    
    IBOutlet UIView *_unloginHeader;
    __weak IBOutlet UIImageView *_unloginHeaderAvaterView;
    __weak IBOutlet UILabel *_unloginHeaderNameLabel;
    __weak IBOutlet UIButton *_unloginHeaderLoginButton;
    __weak IBOutlet UIButton *_unloginHeaderRegisterButton;

    UIButton *_rechargeButton;
    UIButton *_exchangeBUtton;
}

@property (nonatomic, strong) NSArray *arrayOfItem;

@end

@implementation NGGUserViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configueUIComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)configueUIComponents {

    _rechargeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [_rechargeButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x22, 0x4b, 0xf0)] forState:UIControlStateNormal];
    [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rechargeButton.userInteractionEnabled = NO;
    _rechargeButton.layer.cornerRadius = 5.f;
    _rechargeButton.clipsToBounds = YES;
    _exchangeBUtton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [_exchangeBUtton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xfd, 0xbf, 0x2c)] forState:UIControlStateNormal];
    [_exchangeBUtton setTitle:@"兑换" forState:UIControlStateNormal];
    [_exchangeBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _exchangeBUtton.userInteractionEnabled = NO;
    _exchangeBUtton.layer.cornerRadius = 5.f;
    _exchangeBUtton.clipsToBounds = YES;
    _exchangeBUtton.titleLabel.font = [UIFont systemFontOfSize:14];

    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 55.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = NGGSeparatorColor;
    if (isIphoneX) {
        
        _tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
    } else {
        
        _tableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
    }
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [_unloginHeaderRegisterButton setBackgroundImage:[UIImage imageWithColor:NGGPrimaryColor] forState:UIControlStateNormal];
    [_unloginHeaderLoginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_unloginHeaderRegisterButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginedHeaderUserInfoButton setBackgroundImage:[UIImage imageWithColor:[NGGColor999 colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
    [_loginedHeaderUserInfoButton addTarget:self action:@selector(handleUserInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _unloginHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
    _loginedHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 95);
}

- (void)refreshData {
    
    _arrayOfItem = @[
                     @[@{
                           @"image" : @"user_coin",
                           @"name"  : @"我的金币",
                           },
                       @{
                           @"image" : @"user_bean",
                           @"name"  : @"我的金豆",
                           }],
                     @[
                         @{
                             @"image" : @"user_reward",
                             @"name"  : @"我的奖品",
                             },
                         @{
                             @"image" : @"user_coin_deatail",
                             @"name"  : @"金币明细",
                             },
                         @{
                             @"image" : @"user_bean_detail",
                             @"name"  : @"金豆明细",
                             },
                         @{
                             @"image" : @"user_guess_record",
                             @"name"  : @"竞猜记录",
                             },
                         @{
                             @"image" : @"user_message",
                             @"name"  : @"消息中心",
                             },
                         @{
                             @"image" : @"user_QRCode",
                             @"name"  : @"我的邀请码",
                             },],
                     ];
    
    [self refreshUI];

}

- (void)refreshUI {
    
    NGGLoginSession *activeSession = [NGGLoginSession activeSession];
    NGGUser *currentUser = [activeSession currentUser];
    if (activeSession) {
        
        _tableView.tableHeaderView = _loginedHeader;
        _loginedHeaderNameLabel.text = currentUser.nickname;
        [_loginedHeaderAvaterView sd_setImageWithURL:[NSURL URLWithString:currentUser.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    } else {
        
        _tableView.tableHeaderView = _unloginHeader;
    }
    [_tableView reloadData];
}

#pragma mark - button actions

- (void)loginAction {
    
    [self presentLoginViewController];
}

- (void)registerAction {
    
    NGGRegisterViewController *controller = [[NGGRegisterViewController alloc] initWithNibName:@"NGGRegisterViewController" bundle:nil];
    NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];
    controller.hidesBottomBarWhenPushed = YES;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)handleUserInfoButtonClicked:(UIButton *) button {
    
    NGGUserInfoViewController *controller = [[NGGUserInfoViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_arrayOfItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sectionArray = _arrayOfItem[section];
    return [sectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"userCell";
    NSArray *sectionArray = _arrayOfItem[indexPath.section];
    NSDictionary *cellInfo = sectionArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = NGGColor333;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.imageView.image = [UIImage imageNamed:cellInfo[@"image"]];
    cell.textLabel.text = cellInfo[@"name"];
    
    if (indexPath.section == 1) {
        
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.accessoryView = _rechargeButton;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.accessoryView = _exchangeBUtton;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        NGGExchangeViewController *controller = [[NGGExchangeViewController alloc] initWithNibName:@"NGGExchangeViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        
        NGGRechargeViewController *controller = [[NGGRechargeViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }  else if (indexPath.section == 1 && indexPath.row == 4) {
        
        NGGMessageViewController *controller = [[NGGMessageViewController alloc] initWithNibName:@"NGGMessageViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        NGGConsumptionDeatilViewController *controller = [[NGGConsumptionDeatilViewController alloc] initWithNibName:@"NGGConsumptionDeatilViewController" bundle:nil];
        controller.isBean = NO;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
        NGGConsumptionDeatilViewController *controller = [[NGGConsumptionDeatilViewController alloc] initWithNibName:@"NGGConsumptionDeatilViewController" bundle:nil];
        controller.isBean = YES;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        NGGPrizeListViewController *controller = [[NGGPrizeListViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        
        NGGRecordViewController *controller = [[NGGRecordViewController alloc] initWithNibName:@"NGGRecordViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
