//
//  NGGDarenGameResultDetailViewController.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameResultDetailViewController.h"
#import "JYCommonTool.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "NGGDarenGameResultDetailTableViewCell.h"

static NSString *kDarenGameResultDetailTableViewCellIdentifier = @"darenGameResultDetailTableViewCellIdentifier";

@interface NGGDarenGameResultDetailViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UIImageView *_homeLogo;
    __weak IBOutlet UIImageView *_awayLogo;
    __weak IBOutlet UILabel *_homeScoreLabel;
    __weak IBOutlet UILabel *_awayScoreLabel;
    __weak IBOutlet UILabel *_homeNameLabel;
    __weak IBOutlet UILabel *_awayNameLabel;
    __weak IBOutlet UILabel *_timeLabel;

    IBOutlet UIView *_headerView;
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *arrayOfPlayer;

@end

@implementation NGGDarenGameResultDetailViewController

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"赛果";
    [self configueUIComponents];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

#pragma mark - private methods

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 150.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGDarenGameResultDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kDarenGameResultDetailTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_tableView];
    
    _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 140);
    _tableView.tableHeaderView =_headerView;

    _timeLabel.text = [JYCommonTool dateFormatWithInterval:[_resultInfo intForKey:@"match_time"] format:@"yyyy-MM-dd hh:mm"];
    [_homeLogo sd_setImageWithURL:[NSURL URLWithString:[_resultInfo stringForKey:@"h_logo"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [_awayLogo sd_setImageWithURL:[NSURL URLWithString:[_resultInfo stringForKey:@"a_logo"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    _homeNameLabel.text = [_resultInfo stringForKey:@"h_name"];
    _awayNameLabel.text = [_resultInfo stringForKey:@"a_name"];
    
    NSArray *scoreArray = [_resultInfo arrayForKey:@"score"];
    _homeScoreLabel.text = [scoreArray firstObject];
    _awayScoreLabel.text = [scoreArray lastObject];
}

- (void)loadData {
    
    [self showAnimationLoadingHUDWithText:nil onView:[UIApplication sharedApplication].keyWindow];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.signUpList" parameters:@{@"match_id" : [_resultInfo stringForKey:@"match_id"]} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUDOnView:[UIApplication sharedApplication].keyWindow];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            _arrayOfPlayer = [dataArray mutableCopy];
            [_tableView reloadData];
            if ([_arrayOfPlayer count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUDOnView:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)loadMoreData {
    
    NSInteger page = (NSInteger)([_arrayOfPlayer count] / NGGMaxCountPerPage) + 1;
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.signUpList" parameters:@{@"match_id" : [_resultInfo stringForKey:@"match_id"], @"page" : @(page)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_footer endRefreshing];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            [_arrayOfPlayer addObjectsFromArray:dataArray];
            [_tableView reloadData];
            if ([_arrayOfPlayer count] < NGGMaxCountPerPage) {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfPlayer count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGDarenGameResultDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDarenGameResultDetailTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfPlayer[indexPath.row];
    cell.rank = indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
