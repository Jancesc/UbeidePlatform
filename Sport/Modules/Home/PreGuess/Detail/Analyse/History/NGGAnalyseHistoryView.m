//
//  NGGAnalyseHistoryView.m
//  Sport
//
//  Created by Jan on 09/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGAnalyseHistoryView.h"
#import "NGGAnalyseHistoryTableViewCell.h"
#import "NGGAnalyseHistoryheaderView.h"

static NSString *kAnalyseHistoryCellIdentifier = @"analyseHistoryCellIdentifier";

@interface NGGAnalyseHistoryView()<UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UITableView *_tableView;
}

@end

@implementation NGGAnalyseHistoryView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self configueUIComponents];
}

- (void)configueUIComponents {
    
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 30.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGAnalyseHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:kAnalyseHistoryCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"NGGAnalyseHistoryheaderView" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 115);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnalyseHistoryCellIdentifier forIndexPath:indexPath];
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
