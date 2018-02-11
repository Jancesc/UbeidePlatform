//
//  NGGDarenGameDetailPlayerListViewController.m
//  Sport
//
//  Created by Jan on 11/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameDetailPlayerListViewController.h"
#import "NGGDarenGameDetailPlayerListTableViewCell.h"
#import "Masonry.h"
#import "MJRefresh.h"

static NSString *kNGGDarenGameDetailPlayerListTableViewCellIdentifier = @"NGGDarenGameDetailPlayerListTableViewCell";
@interface NGGDarenGameDetailPlayerListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *_tableView;
    IBOutlet UIView *_headerView;
}

@property (nonatomic, strong) NSArray *arrayOfPlayer;
@end

@implementation NGGDarenGameDetailPlayerListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
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
    _tableView.rowHeight = 50.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGDarenGameDetailPlayerListTableViewCell" bundle:nil] forCellReuseIdentifier:kNGGDarenGameDetailPlayerListTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
//    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
//    _tableView.tableHeaderView = _headerView;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self configueHeader];
    _tableView.tableHeaderView = _headerView;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}

- (void)refreshData {
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.expertDetail" parameters:@{@"match_id" : _gameModel.matchID} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_tableView.mj_header endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _gameDetailInfo = [dict mutableCopy];
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)refreshUI {
    
    _arrayOfPlayer = [_gameDetailInfo arrayForKey:@"list"];
    [_tableView reloadData];
}

- (void)setGameDetailInfo:(NSDictionary *)gameDetailInfo {
    
    _gameDetailInfo = gameDetailInfo;
    
    [self refreshUI];
}

- (void)configueHeader {
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel *tipsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 0.5 * SCREEN_WIDTH - 70, 30)];
    tipsLabel1.text = @"用户名";
    tipsLabel1.textColor = NGGColor666;
    tipsLabel1.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:tipsLabel1];
    
    UILabel *tipsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0.5 * SCREEN_WIDTH, 0, 0.5 * SCREEN_WIDTH - 10, 30)];
    tipsLabel2.text = @"报名时间";
    tipsLabel2.textColor = NGGColor666;
    tipsLabel2.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:tipsLabel2];

}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfPlayer count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ;NGGDarenGameDetailPlayerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNGGDarenGameDetailPlayerListTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfPlayer[indexPath.row];

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
