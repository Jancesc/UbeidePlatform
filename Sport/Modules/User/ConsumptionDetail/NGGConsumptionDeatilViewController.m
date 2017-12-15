//
//  NGGConsumptionDeatilViewController.m
//  Sport
//
//  Created by Jan on 28/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGConsumptionDeatilViewController.h"
#import "NGGConsumptionTableViewCell.h"
#import "MJRefresh.h"

static NSString *kNGGConsumptionCellIdentifier = @"NGGConsumptionTableViewCell";

@interface NGGConsumptionDeatilViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UIImageView *_noticeImage;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UILabel *_countTipsLabel;
    __weak IBOutlet UISegmentedControl *_segmentControl;
    __weak IBOutlet UITableView *_tableView;
    
    UILabel *_footerLabel;
}

@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSArray *arrayOfReceive;
@property (nonatomic, strong) NSArray *arrayOfSpent;

@end

@implementation NGGConsumptionDeatilViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = NGGGlobalBGColor;
    [self configueUIComponents];
    if (_isBean) {
        
        _URL = @"/api.php?method=info.beanDetail";
    } else {
        
        _URL = @"/api.php?method=info.coinDetail";
    }
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
    
    NGGUser *user = [NGGLoginSession activeSession].currentUser;
    if (_isBean) {//金豆明细
        
        self.title = @"金豆明细";
        _noticeImage.image = [UIImage imageNamed:@"bean"];
        _countLabel.text = user.bean;
        _countTipsLabel.text = @"当前金豆余额";
    } else {//金币明细
      
        self.title = @"金币明细";
        _noticeImage.image = [UIImage imageNamed:@"gold"];
        _countLabel.text = user.coin;
        _countTipsLabel.text = @"当前金币余额";
    }
    
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : NGGColor333, NSFontAttributeName : [UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName :  [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    [_segmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 60.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGConsumptionTableViewCell" bundle:nil] forCellReuseIdentifier:kNGGConsumptionCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerLabel.text = @"只显示最近30天的记录";
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.font = [UIFont systemFontOfSize:14.f];
    footerLabel.textColor = NGGColor999;
    footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel = footerLabel;
    
    NGGEmptyView *emptyView = [[NGGEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_H(_tableView))];
    _tableView.backgroundView = emptyView;
}

#pragma mark - private methods

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

- (void)loadMoreData {
    
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfReceive : _arrayOfSpent;
    NSInteger page = (NSInteger)([array count] / NGGMaxCountPerPage) + 1;
    NSDictionary *params = @{@"type" : @(_segmentControl.selectedSegmentIndex), @"page" : @(page)};
    
    [[NGGHTTPClient defaultClient] postPath:_URL parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_footer endRefreshing];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            if (_segmentControl.selectedSegmentIndex == 0) {
                
                _arrayOfReceive = dataArray;
            } else {
                
                _arrayOfSpent = dataArray;
            }
            [_tableView reloadData];
            if ([dataArray count] <NGGMaxCountPerPage) {
                
                [_tableView.mj_footer endRefreshing];
                _tableView.tableFooterView = _footerLabel;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
    }];
    
}

- (void)loadData {
    
    NSDictionary *params = @{@"type" : @(_segmentControl.selectedSegmentIndex)};
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:_URL parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            if (_segmentControl.selectedSegmentIndex == 0) {
                
                _arrayOfReceive = dataArray;
            } else {
                
                _arrayOfSpent = dataArray;
            }
            [_tableView reloadData];
            if ([dataArray count] == NGGMaxCountPerPage) {
                
                [self setupLoadMoreFooter];
            }else if ([dataArray count] > 0) {
                
                _tableView.tableFooterView = _footerLabel;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
        [self dismissHUD];
    }];
}

- (void)segmentControlValueChanged:(UISegmentedControl *) segmentControl {
    
    [_tableView reloadData];
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfReceive : _arrayOfSpent;
    if (array == nil) {
        
        [self loadData];
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _segmentControl.selectedSegmentIndex == 0 ? [_arrayOfReceive count] : [_arrayOfSpent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfReceive : _arrayOfSpent;

    NGGConsumptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNGGConsumptionCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01f;
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
