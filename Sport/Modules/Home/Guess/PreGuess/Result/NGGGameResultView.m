//
//  NGGGameResultView.m
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameResultView.h"
#import "NGGGameResultTableViewCell.h"
#import "Masonry.h"
#import "MJRefresh.h"

static NSString *kGameResultTableViewCellIdentidier = @"gameResultTableViewCellIdentidier";

@interface NGGGameResultView()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation NGGGameResultView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configueUIComponents];
    }
    
    return self;
}

- (void)configueUIComponents {

    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 150.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGGameResultTableViewCell" bundle:nil] forCellReuseIdentifier:kGameResultTableViewCellIdentidier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_header = header;
}

-(void)setArrayOfGameResult:(NSArray *)arrayOfGameResult {
    
    if ([arrayOfGameResult count] != 0 && [arrayOfGameResult count] % NGGMaxCountPerPage == 0) {
        
        [self setupLoadMoreFooter];
    } else if ([arrayOfGameResult count] - [_arrayOfGameResult count] < NGGMaxCountPerPage) {
        
        _tableView.mj_footer = nil;
    }
    _arrayOfGameResult = [arrayOfGameResult copy];
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}

- (void)loadMoreData {
    
    if (_delegate && [_delegate respondsToSelector:@selector(loadMoreGameResultInfo)]) {
        
        [_delegate loadMoreGameResultInfo];
    }
}

- (void)refreshData {
    
    if (_delegate && [_delegate respondsToSelector:@selector(refreshGameResultInfo)]) {
        
        _arrayOfGameResult = nil;
        [_delegate refreshGameResultInfo];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfGameResult count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGGGameResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameResultTableViewCellIdentidier
                                                            forIndexPath:indexPath];
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
    

}


@end

