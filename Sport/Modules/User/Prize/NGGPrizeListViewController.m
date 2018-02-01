//
//  NGGPrizeListViewController.m
//  Sport
//
//  Created by Jan on 08/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGPrizeListViewController.h"
#import "NGGPrizeTableViewCell.h"
#import "MJRefresh.h"
#import "Masonry.h"

static NSString *kPrizeCellIdentifier = @"prizeCellIdentifier";

@interface NGGPrizeListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *arrayOfPrize;

@end

@implementation NGGPrizeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的奖品";
    [self configueUIComponents];
    [self  refreshData];
}

- (void)configueUIComponents {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - HOME_INDICATOR) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];

    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = NGGColorCCC;
    _tableView.rowHeight = 120.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGPrizeTableViewCell" bundle:nil] forCellReuseIdentifier:kPrizeCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

- (void)loadMoreData {
    
    NSInteger page = (NSInteger)([_arrayOfPrize count] / NGGMaxCountPerPage) + 1;

    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.myPrize" parameters:@{@"page" : @(page)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        [_tableView.mj_header endRefreshing];
        [self dismissHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            [_arrayOfPrize addObjectsFromArray:dataArray];
            [_tableView reloadData];
            if ([dataArray count] < NGGMaxCountPerPage) {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self dismissHUD];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)refreshData {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.myPrize" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        [_tableView.mj_header endRefreshing];
        [self dismissHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            _arrayOfPrize = [NSMutableArray arrayWithArray:dataArray];
            if ([dataArray count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self dismissHUD];
        [_tableView.mj_header endRefreshing];
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfPrize count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGPrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPrizeCellIdentifier
                                                                       forIndexPath:indexPath];
    cell.cellInfo = _arrayOfPrize[indexPath.row];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}



@end
