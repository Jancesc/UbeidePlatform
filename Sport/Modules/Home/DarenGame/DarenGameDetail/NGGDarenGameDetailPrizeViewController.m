//
//  NGGDarenGameDetailPrizeViewController.m
//  Sport
//
//  Created by Jan on 11/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameDetailPrizeViewController.h"
#import "NGGDarenGameDetailPrizeTableViewCell.h"
#import "Masonry.h"
#import "MJRefresh.h"

static NSString *kNGGDarenGameDetailPrizeTableViewCellIdentifier = @"NGGDarenGameDetailPrizeTableViewCell";
@interface NGGDarenGameDetailPrizeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *_tableView;
    IBOutlet UIView *_headerView;
}

@property (nonatomic, strong) NSArray *arrayOfPrize;
@end

@implementation NGGDarenGameDetailPrizeViewController


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
    [_tableView registerNib:[UINib nibWithNibName:@"NGGDarenGameDetailPrizeTableViewCell" bundle:nil] forCellReuseIdentifier:kNGGDarenGameDetailPrizeTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    _tableView.tableHeaderView = _headerView;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
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
    
    _arrayOfPrize = [_gameDetailInfo arrayForKey:@"prize"];
    [_tableView reloadData];
}

- (void)setGameDetailInfo:(NSDictionary *)gameDetailInfo {
    
    _gameDetailInfo = gameDetailInfo;
    
    [self refreshUI];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfPrize count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGDarenGameDetailPrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNGGDarenGameDetailPrizeTableViewCellIdentifier forIndexPath:indexPath];
    cell.count = _arrayOfPrize[indexPath.row];
    cell.index = indexPath.row;
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
