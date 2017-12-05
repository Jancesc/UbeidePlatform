//
//  NGGRankView.m
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRankView.h"
#import "NGGRankTableViewCell.h"
#import "NGGRankHeaderView.h"
#import "Masonry.h"
#import "MJRefresh.h"

static NSString *kNGGRankTableViewCellIdentifier = @"nGGRankTableViewCellIdentifier";

@interface NGGRankView()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
    NGGRankHeaderView *_headerView;
}

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSArray *rankArray;

@end

@implementation NGGRankView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configueUIComponents];
    }
    return self;
}

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 70.f;
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
    
    NGGRankHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"NGGRankHeaderView" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 75);
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}


- (void)refreshData {
    
    if (_delegate && [_delegate respondsToSelector:@selector(refreshRankInfo)]) {
        
        [_delegate refreshRankInfo];
    }
}

- (void)setRankDict:(NSDictionary *)rankDict {
    
    _rankDict = rankDict;
    _userInfo = [rankDict dictionaryForKey:@"user_rank"];
    _rankArray = [rankDict arrayForKey:@"list"];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    _headerView.info = _userInfo;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_rankArray count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNGGRankTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _rankArray[indexPath.row];
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

