//
//  NGGDarenGameListViewController.m
//  Sport
//
//  Created by Jan on 07/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameListViewController.h"
#import "NGGDarenGameListTableViewCell.h"
#import "NGGDarenGameListHeaderView.h"
#import "MJRefresh.h"
#import "NGGDarenGameDetailViewController.h"

static NSString *kDarenGameListTableViewCellIdentifier = @"darenGameListTableViewCellIdentifier";

@interface NGGDarenGameListViewController ()<UITableViewDelegate, UITableViewDataSource,NGGDarenGameListTableViewCellDelegate> {
    
    UITableView *_tableView;
    NSTimer *_timer;
    NGGDarenGameListHeaderView *_headerView;
}

@property (nonatomic, strong) NSMutableArray *arrayOfGameList;

@end

@implementation NGGDarenGameListViewController

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, SCREEN_HEIGHT - 134)];
    [self configueUIComponents];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.view.frame = SCREEN_BOUNDS;
//    [self loadData];
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

- (void)clear {
    
    if (_timer) {
        
        [_timer invalidate];
    }
}
#pragma mark - private methods

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 205.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGDarenGameListTableViewCell" bundle:nil] forCellReuseIdentifier:kDarenGameListTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_tableView];
    
    if (_timer) {
        
        [_timer invalidate];
    }
    NGGWeakSelf
    _timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(countTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"NGGDarenGameListHeaderView" owner:nil options:nil] lastObject];
    _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 100);
    _tableView.tableHeaderView =_headerView;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}

- (void)loadData {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.expertList" parameters:@{@"page" : @0} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            _headerView.count = [dict stringForKey:@"total"];
            _arrayOfGameList = [[dict arrayForKey:@"list"] mutableCopy];
            [_tableView reloadData];
            if ([_arrayOfGameList count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUD];
    }];
}

- (void)refreshData {
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.expertList" parameters:@{@"page" : @0} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_header endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _headerView.count = [dict stringForKey:@"total"];
            _arrayOfGameList = [[dict arrayForKey:@"list"] mutableCopy];
            [_tableView reloadData];
            if ([_arrayOfGameList count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_header endRefreshing];
    }];
}


- (void)countTime {
    
    NSArray *cellArray = [_tableView visibleCells];
    
    for (NGGDarenGameListTableViewCell *cell in cellArray) {
        
        [cell countTime];
    }
}

- (void)loadMoreData {
    
    NSInteger page = (NSInteger)([_arrayOfGameList count] / NGGMaxCountPerPage) + 1;
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.expertList" parameters:@{@"page" : @(page)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_footer endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            NSArray *gameListArray = [dict arrayForKey:@"list"];

            [_arrayOfGameList addObjectsFromArray:gameListArray];;
            [_tableView reloadData];
            _headerView.count = [dict stringForKey:@"total"];
            
            if ([gameListArray count] < NGGMaxCountPerPage) {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - NGGDarenGameListTableViewCellDelegate

- (void)gameListTableViewcellDidFinishCountDown:(NGGDarenGameListTableViewCell *)cell {
    
    [_arrayOfGameList removeObject:cell.cellInfo];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource    

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfGameList count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGDarenGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDarenGameListTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfGameList[indexPath.row];
    cell.delegate = self;
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
    NGGDarenGameDetailViewController *controller = [[NGGDarenGameDetailViewController alloc] initWithNibName:@"NGGDarenGameDetailViewController" bundle:nil];
    controller.model = [[NGGGameListModel alloc] initWithInfo:_arrayOfGameList[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
