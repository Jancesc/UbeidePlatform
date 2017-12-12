//
//  NGGFollowGameView.m
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGFollowGameView.h"
#import "NGGFollowGameTableViewCell.h"
#import "Masonry.h"

static NSString *kFollowGameTableViewCellidentifier = @"followGameTableViewCellidentifier";

@interface NGGFollowGameView()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}
@end

@implementation NGGFollowGameView

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
    _tableView.rowHeight = 44.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGFollowGameTableViewCell" bundle:nil] forCellReuseIdentifier:kFollowGameTableViewCellidentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 0.333 * (SCREEN_WIDTH - 70), 20)];
    timeLabel.text = @"开赛时间";
    timeLabel.textColor = NGGPrimaryColor;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:timeLabel];
    
    UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.333 * (SCREEN_WIDTH - 70) + 35, 20, SCREEN_WIDTH - 35 - (0.333 * (SCREEN_WIDTH - 70)), 20)];
    teamLabel.text = @"球队";
    teamLabel.textColor = NGGPrimaryColor;
    teamLabel.font = [UIFont systemFontOfSize:14];
    teamLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:teamLabel];
    _tableView.tableHeaderView = headerView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFollowGameTableViewCellidentifier forIndexPath:indexPath];
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
