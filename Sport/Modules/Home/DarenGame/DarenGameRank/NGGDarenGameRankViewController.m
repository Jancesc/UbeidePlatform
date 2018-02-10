//
//  NGGDarenGameRankViewController.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameRankViewController.h"
#import "NGGRankTableViewCell.h"
#import "NGGDarenGameRankHeader.h"
#import "Masonry.h"
#import "MJRefresh.h"

static NSString *kNGGRankTableViewCellIdentifier = @"nGGRankTableViewCellIdentifier";

@interface NGGDarenGameRankViewController() <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
    NGGDarenGameRankHeader *_headerView;
}

@property (nonatomic, strong) NSArray *arrayOfRank;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation NGGDarenGameRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, SCREEN_HEIGHT - 134)];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 75.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGRankTableViewCell" bundle:nil] forCellReuseIdentifier:kNGGRankTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    NGGDarenGameRankHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"NGGDarenGameRankHeader" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}

- (void)loadData {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.ranking" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _arrayOfRank = [[dict arrayForKey:@"list"] mutableCopy];
            _userInfo = [dict dictionaryForKey:@"user_rank"];
            _headerView.info = _userInfo;
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUD];
    }];
}

- (void)refreshData {
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.ranking" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_header endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _arrayOfRank = [[dict arrayForKey:@"list"] mutableCopy];
            _userInfo = [dict dictionaryForKey:@"user_rank"];
            _headerView.info = _userInfo;
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfRank count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNGGRankTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfRank[indexPath.row];
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

