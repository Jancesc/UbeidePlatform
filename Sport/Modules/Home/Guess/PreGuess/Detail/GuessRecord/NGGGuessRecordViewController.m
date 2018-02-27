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
    self.title = @"投注记录";
    [self configueUIComponents];
    [self refreshUI];
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
}

- (void)setGameID:(NSString *)gameID {
    
    _gameID = gameID;
    [self loadRecord];
}

- (void)loadRecord {
    
    [self showLoadingHUDWithText:nil];
    
    NSString *urlString = nil;
    switch (_gameType) {
        case (NGGGameTypeLive): {
            
            urlString = @"/api.php?method=live.playRecord";
                break;
        }
        case (NGGGameTypePreGame): {
          
            urlString = @"/api.php?method=game.playRecord";
            break;
        }
        case (NGGGameTypeDaren): {
            
            urlString = @"/api.php?method=expert.playRecord";
            break;
        }
        default:
            break;
    }
    [[NGGHTTPClient defaultClient] postPath:urlString parameters:@{@"match_id" : _gameID} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            //            "h_name": "里昂",
            //            "a_name": "马赛",
            //            "match_time": "1513540800",
            //            "score": "1:2",
            //            "status": "0",
            //            "profit": -10100,
            //            "bean_total": 10100,
            //            "win_total": 0
            NSDictionary *gameInfo = [dict dictionaryForKey:@"match"];
            _gameModel = [NGGGameModel new];
            _gameModel.homeName = [gameInfo stringForKey:@"h_name"];
            _gameModel.awayName = [gameInfo stringForKey:@"a_name"];
            _gameModel.startTime = [gameInfo stringForKey:@"match_time"];
            
            NSArray *scoreArray = [gameInfo arrayForKey:@"score"];
            if ([scoreArray count] == 0) {
                
                scoreArray = @[@"0", @"0"];
            }
            _gameModel.homeScore = [scoreArray firstObject];
            _gameModel.awayScore = [scoreArray lastObject];
            _gameModel.status = [gameInfo stringForKey:@"status"];
            _gameModel.profit = [gameInfo stringForKey:@"profit"];
            _gameModel.count = [gameInfo stringForKey:@"bean_total"];
            _gameModel.winCount = [gameInfo stringForKey:@"win_total"];
            
            NSArray *guessedArray = [dict arrayForKey:@"record"];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSInteger index = 0; index < [guessedArray count]; index++) {
                
                NGGGuessRecordModel *model = [[NGGGuessRecordModel alloc] initWithInfo:guessedArray[index]];
                [arrayM addObject:model];
            }
            
            _arrayOfRecord = [arrayM copy];
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)refreshUI {
    
    [_tableView reloadData];
    if ([_arrayOfRecord count] == 0) {
        
        _tableView.userInteractionEnabled = NO;
    } else {
        
        _tableView.userInteractionEnabled = YES;
    }
    if (_gameModel) {
        
        _homeLabel.text = _gameModel.homeName;
        _awayLabel.text = _gameModel.awayName;
        if (_gameModel.status.integerValue == 0) {
            
            _scoreLabel.text = @"未开赛";
        } else {
            
            _scoreLabel.text = [NSString stringWithFormat:@"%@ : %@", _gameModel.homeScore, _gameModel.awayScore];
        }
        
        _timeLabel.text = [JYCommonTool dateFormatWithInterval:_gameModel.startTime.integerValue format:@"yyyy-MM-dd HH:mm"];
        
        if (_gameModel.profit.integerValue < 0) {
            
            _profitLabel.textColor = NGGPrimaryColor;
        } else {
            
            _profitLabel.textColor = NGGThirdColor;
        }
        _profitLabel.text = [JYCommonTool stringDisposeWithFloat:_gameModel.profit.floatValue];
        
        _totalGuessLabel.text = [JYCommonTool stringDisposeWithFloat:_gameModel.count.floatValue];
        
        if (_gameModel.winCount < 0) {
            
            _totalWinLabel.textColor = NGGPrimaryColor;
        } else {
            
            _totalWinLabel.textColor = NGGThirdColor;
        }
        
        _totalWinLabel.text = [JYCommonTool stringDisposeWithFloat:_gameModel.winCount.floatValue];
        
        if ([_arrayOfRecord count] == 0) {
            
            NGGEmptyView *emptyView = [[NGGEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_H(_tableView) + 100)];
            _tableView.backgroundView = emptyView;
        } else {
            
            _tableView.backgroundView = nil;
        }
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
