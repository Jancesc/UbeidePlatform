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

static NSString *kNGGRankTableViewCellIdentifier = @"nGGRankTableViewCellIdentifier";

@interface NGGRankView()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation NGGRankView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configueUIComponents];
    }
    return self;
}

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
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
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"NGGRankHeaderView" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 75);
    _tableView.tableHeaderView = headerView;
    
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNGGRankTableViewCellIdentifier forIndexPath:indexPath];
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

