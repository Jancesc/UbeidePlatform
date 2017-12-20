//
//  NGGGuessRecordViewController.m
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessRecordViewController.h"
#import "NGGGuessRecordTableViewCell.h"
#import "JYCommonTool.h"

static NSString *kGuessRecordCellIdentifier = @"guessRecordCell";

@interface NGGGuessRecordViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    __strong IBOutlet UIView *_headerView;
    __strong IBOutlet  UIView *_bottomView;
    
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
    if ([_arrayOfRecord count] == 0) {
        
        _tableView.userInteractionEnabled = NO;
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGColorCCC;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 50.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [_tableView registerNib:[UINib nibWithNibName:@"NGGGuessRecordTableViewCell" bundle:nil] forCellReuseIdentifier:kGuessRecordCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_tableView];
    
    _homeLabel.text = _gameModel.homeName;
    _awayLabel.text = _gameModel.awayName;
    _scoreLabel.text = _gameModel.score;
    _timeLabel.text = [JYCommonTool dateFormatWithInterval:_gameModel.startTime.integerValue format:@"yyyy-MM-dd HH:mm"];
    if (_gameModel.profit < 0) {
        
        _profitLabel.textColor = NGGPrimaryColor;
    } else {
        
        _profitLabel.textColor = NGGThirdColor;
    }
    _profitLabel.text = [JYCommonTool stringDisposeWithFloat:_gameModel.profit];
    
    _totalGuessLabel.text = [JYCommonTool stringDisposeWithFloat:_gameModel.count];
    
    if (_gameModel.winCount < 0) {
        
        _totalWinLabel.textColor = NGGPrimaryColor;
    } else {
        
        _totalWinLabel.textColor = NGGThirdColor;
    }
    
    _totalWinLabel.text = [JYCommonTool stringDisposeWithFloat:_gameModel.winCount];

    if ([_arrayOfRecord count] == 0) {
        
        NGGEmptyView *emptyView = [[NGGEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_H(_tableView))];
        _tableView.backgroundView = emptyView;
    }
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
    
    return 195.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([_arrayOfRecord count] > 0) {
        
        return 50.f;
    }
    return 0.01f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 195);
    return _headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if ([_arrayOfRecord count] > 0) {
        
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        return _bottomView;
    }
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
