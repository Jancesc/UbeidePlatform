//
//  NGGSystemMessageViewController.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGSystemMessageViewController.h"
#import "NGGSystemMessageTableViewCell.h"
#import "MJRefresh.h"

static NSString *kSystemMessageTableViewCellIdentifier = @"wystemMessageTableViewCellIdentifier";
@interface NGGSystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *arrayOfMessage;
@end

@implementation NGGSystemMessageViewController

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - HOME_INDICATOR) style: UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 75.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGSystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kSystemMessageTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    [self configueData];
}


- (void)configueData {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.msgList" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
        
            [self showErrorHUDWithText:nil];
        }];
        if (dataArray) {
            
            _arrayOfMessage = [dataArray mutableCopy];
            [_tableView reloadData];
            if ([dataArray count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            } else {
                
                _tableView.mj_footer = nil;
            }
            
            if ([dataArray count] == 0) {
                
                [self showEmptyViewInView:_tableView.backgroundView];
                
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUD];
    }];
}

- (void)loadMoreData {
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.msgList" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_footer endRefreshing];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:nil];
        }];
        if (dataArray) {
            
            [_arrayOfMessage addObjectsFromArray:dataArray];
            [_tableView reloadData];
            if ([dataArray count] < NGGMaxCountPerPage) {
                
                _tableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfMessage count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGSystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemMessageTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfMessage[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [NGGSystemMessageTableViewCell rowHeightWithCellInfo:_arrayOfMessage[indexPath.row]];
}

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
    
    //    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.row == 0)
    //    {
    //        DMAgencyAddBankAccountViewController *controller =
    //        [[DMAgencyAddBankAccountViewController alloc] initWithNibName:@"DMAgencyAddBankAccountViewController" bundle:nil];
    //        controller.delegate = self;
    //        [self.navigationController pushViewController:controller animated:YES];
    //    }
    //    else if (indexPath.row == 1)
    //    {
    //        DMAgencyAddAliPayAccountViewController *contoller = [[DMAgencyAddAliPayAccountViewController alloc] initWithNibName:@"DMAgencyAddAliPayAccountViewController" bundle:nil];
    //        contoller.delegate = self;
    //        [self.navigationController pushViewController:contoller animated:YES];
    //    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

