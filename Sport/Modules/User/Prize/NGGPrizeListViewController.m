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
#import "NGGAddressViewController.h"

static NSString *kPrizeCellIdentifier = @"prizeCellIdentifier";

@interface NGGPrizeListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *arrayOfPrize;
@property (nonatomic, strong) NSMutableDictionary *dictOfAddress;


@end

@implementation NGGPrizeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的奖品";
    [self configueUIComponents];
    [self  refreshData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NGGUserDidLoginNotificationName object:nil];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configueUIComponents {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - HOME_INDICATOR) style:UITableViewStyleGrouped];
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
        
        [_tableView.mj_footer endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            NSArray *dataArray = [dict arrayForKey:@"list"];
            [_arrayOfPrize addObjectsFromArray:dataArray];
            [_tableView reloadData];
            if ([dataArray count] < NGGMaxCountPerPage) {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)refreshData {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.myPrize" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        [_tableView.mj_header endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
        
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _arrayOfPrize = [[dict arrayForKey:@"list"] mutableCopy];
            _dictOfAddress = [[dict dictionaryForKey:@"address"] mutableCopy];
            if ([_arrayOfPrize count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
            if ([_arrayOfPrize count] == 0) {
                
                [self showEmptyViewInView:_tableView];
            } else {
                
                [self dismissEmptyView];
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
    NSDictionary *prizeInfo = _arrayOfPrize[indexPath.row];
    NSInteger status = [prizeInfo intForKey:@"status"];
    switch (status) {
            
        case 1: {//待领取
            
            NGGAddressViewController *controller = [[NGGAddressViewController alloc] initWithNibName:@"NGGAddressViewController" bundle:nil];
            controller.dictOfAddress = _dictOfAddress;
            controller.prizeInfo = _arrayOfPrize[indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
            
            break;
        }
        case 2: {//已领取
            
    
            break;
        }
        case 3: {//已截止
            
  
            break;
        }
        default:
            break;
    }
}



@end
