//
//  NGGGuessRecordViewController.m
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessRecordViewController.h"
#import "NGGGuessRecordTableViewCell.h"

static NSString *kGuessRecordCellIdentifier = @"guessRecordCell";

@interface NGGGuessRecordViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UIView *_headerView;
    __weak IBOutlet  UIView *_bottomView;
    __weak IBOutlet UIImageView *_homeImageView;
    __weak IBOutlet UIImageView *_awayImageView;
    __weak IBOutlet  UILabel *_homeLabel;
    __weak IBOutlet  UILabel *_awayLabel;
    __weak IBOutlet  UILabel *_scoreLabel;
    __weak IBOutlet  UILabel *_timeLabel;
    __weak IBOutlet UILabel *_profitLabel;
   
    __weak IBOutlet  UILabel *_totalGuessLabel;
    __weak IBOutlet  UILabel *_totalWinLabel;
    
    UITableView *_tableView;

}

@end

@implementation NGGGuessRecordViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"赛前记录";
    [self configueUIComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 50.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGGuessRecordTableViewCell" bundle:nil] forCellReuseIdentifier:kGuessRecordCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = _bottomView;
   
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfRecord count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGGuessRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuessRecordCellIdentifier forIndexPath:indexPath];
    cell.model = _arrayOfRecord[indexPath.row];
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
