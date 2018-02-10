//
//  NGGDarenGameResultViewController.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameResultViewController.h"
#import "NGGDarenGameResultTableViewCell.h"
#import "MJRefresh.h"
#import "NGGDarenGameResultDetailViewController.h"

static NSString *kDarenGameResultTableViewCellIdentifier = @"darenGameResultTableViewCellIdentifier";
@interface NGGDarenGameResultViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *arrayOfGameResult;

@end

@implementation NGGDarenGameResultViewController


- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, SCREEN_HEIGHT - 134)];
    [self configueUIComponents];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    self.view.frame = SCREEN_BOUNDS;
    [self loadData];
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

#pragma mark - private methods

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 200.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGDarenGameResultTableViewCell" bundle:nil] forCellReuseIdentifier:kDarenGameResultTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_tableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}

- (void)loadData {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.gameResult" parameters:@{@"page" : @0, @"type" : @2} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            _arrayOfGameResult = [dataArray mutableCopy];
            [_tableView reloadData];
            if ([_arrayOfGameResult count] == NGGMaxCountPerPage) {
                
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
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.gameResult" parameters:@{@"page" : @0, @"type" : @2} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_header endRefreshing];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            _arrayOfGameResult = [dataArray mutableCopy];
            [_tableView reloadData];
            if ([_arrayOfGameResult count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    NSInteger page = (NSInteger)([_arrayOfGameResult count] / NGGMaxCountPerPage) + 1;
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.gameResult" parameters:@{@"page" : @(page), @"type" : @2} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_footer endRefreshing];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            [_arrayOfGameResult addObjectsFromArray:dataArray];;
            [_tableView reloadData];
            
            if ([dataArray count] < NGGMaxCountPerPage) {
                
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
    
    return [_arrayOfGameResult count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGDarenGameResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDarenGameResultTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfGameResult[indexPath.row];
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
    NGGDarenGameResultDetailViewController *controller = [[NGGDarenGameResultDetailViewController alloc] initWithNibName:@"NGGDarenGameResultDetailViewController" bundle:nil];
    controller.resultInfo = _arrayOfGameResult[indexPath.row];
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
