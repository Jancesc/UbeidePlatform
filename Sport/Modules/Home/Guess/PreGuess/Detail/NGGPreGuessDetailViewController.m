//
//  NGGPreGuessDetailViewController.m
//  sport
//
//  Created by Jan on 06/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGPreGuessDetailViewController.h"
#import "Masonry.h"
#import "POP.h"
#import "NGGGuessCollectionViewCell.h"
#import "NGGGuess2RowsCollectionViewCell.h"
#import "NGGDetailHeaderReusableView.h"
#import "NGGDetailAnalyseView.h"
#import "NGGGameModel.h"
#import "NGGWebSocketHelper.h"
#import "NGGGuessDescriptionCollectionViewCell.h"
#import "NGGGuessOrderView.h"
#import "NGGGuessOrderDoneView.h"
#import "MJRefresh.h"
#import "SCLAlertView.h"
#import "NGGRechargeViewController.h"
#import "NGGGuessRecordModel.h"
#import "NGGGuessRecordViewController.h"
#import "JYCommonTool.h"

static NSString *kGuessCellIdentifier = @"NGGGuessCollectionViewCell";
static NSString *kGuess2RowsCellIdentifier = @"NGGGuess2RowsCollectionViewCell";
static NSString *kDescriptionCellIdentifier = @"NGGDescriptionCellIdentifier";
static NSString *kDetailHeaderIdentifier = @"NGGDetailHeaderReusableView";

@interface NGGPreGuessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NGGWebSocketHelperDelegate, NGGGuessOrderViewDelegate, NGGGuessOrderDoneViewDelegate> {
    
    __weak IBOutlet UIButton *_guessButton;
    __weak IBOutlet UIButton *_liveButton;
    __weak IBOutlet UIButton *_analyseButton;
    __weak IBOutlet UIView *_pageSwitchTipsView;
    __weak IBOutlet UICollectionView *_collectionView;
    
    __weak IBOutlet UILabel *_beanLabel;
    __weak IBOutlet UILabel *_homeLabel;
    __weak IBOutlet UILabel *_awayLabel;
    __weak IBOutlet UILabel *_homeScore;
    __weak IBOutlet UILabel *_awayScore;
    __weak IBOutlet UIImageView *_homeImageView;
    __weak IBOutlet UIImageView *_awayImageView;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_statusLabel;
    
    __weak IBOutlet UIButton *_moreBeanButton;
    __weak IBOutlet UIButton *_recordButton;
    __weak IBOutlet UIButton *_helpButton;
    
    NGGGuessOrderView *_makeOrderView;
    NGGGuessOrderDoneView *_resultView;
}

@property (nonatomic, strong) NGGGameModel *gameModel;
@property (nonatomic, strong) UIView *analyseView;
@property (nonatomic, strong) NSArray *arrayOfGuessed;//已经投注的列表
@property (nonatomic, strong) NSMutableDictionary *dictionaryOfGuessed;

@end

@implementation NGGPreGuessDetailViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"赛前";
    [self configueUIComponents];
    _dictionaryOfGuessed = [NSMutableDictionary dictionary];
    [NGGWebSocketHelper shareHelper].delegate = self;
    [[NGGWebSocketHelper shareHelper] webSocketOpen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    SRReadyState state = [[NGGWebSocketHelper shareHelper] socketStatus];
    if (state == SR_CLOSED ||
        state == SR_CLOSING) {
        
        [[NGGWebSocketHelper shareHelper] webSocketOpen];
    }
}
    
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    if (self.navigationController == nil) {
        
        [NGGWebSocketHelper shareHelper].delegate = nil;
        [[NGGWebSocketHelper shareHelper] webSocketClose];
    }
}

- (void)loadDetailInfo {
    
    NSDictionary *params = @{@"match_id" : _model.matchID, @"method" : @"game.gameDetail"};
    NGGLoginSession *session = [NGGLoginSession activeSession];
    NSMutableDictionary *inputParams = [params mutableCopy];
    if (session) {
        [inputParams setObject:session.currentUser.token forKey:@"token"];
        [inputParams setObject:session.currentUser.uid forKey:@"uid"];
    }
    params = [[NGGHTTPClient defaultClient] signedParametersWithParameters:inputParams];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[NGGWebSocketHelper shareHelper] sendData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - private methods

- (void)configueUIComponents {
    
    [_guessButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_liveButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_analyseButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _guessButton.selected = YES;
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 50) / 3.0;
    _pageSwitchTipsView.frame = CGRectMake(15, 42, buttonWidth, 3);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGGuessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGuessCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGGuess2RowsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGuess2RowsCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGGuessDescriptionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDescriptionCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGDetailHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = NGGSeparatorColor;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _collectionView.mj_header = header;
    
    _analyseView = [[[NSBundle mainBundle] loadNibNamed:@"NGGDetailAnalyseView" owner:nil options:nil] lastObject];
    _analyseView.hidden = YES;
    [self.view addSubview:_analyseView];
    [_analyseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_collectionView.mas_top);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    _makeOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NGGGuessOrderView" owner:nil options:nil] lastObject];
    _makeOrderView.delegate = self;
    _makeOrderView.hidden = YES;
    [self.view addSubview:_makeOrderView];
    [_makeOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(140.f);
        
    }];
    
    _resultView = [[[NSBundle mainBundle] loadNibNamed:@"NGGGuessOrderDoneView" owner:nil options:nil] lastObject];
    _resultView.delegate = self;
    _resultView.hidden = YES;
    [self.view addSubview:_resultView];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(140.f);
        
    }];
    
    [_moreBeanButton addTarget:self action:@selector(moreBeanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_helpButton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshUI {
    
    [_collectionView reloadData];
    [_collectionView.mj_header endRefreshing];
    
    [self hideMakeOrderView];
    [self hideOrderDoneView];
    
    _beanLabel.text = [NSString stringWithFormat:@"%@金豆", [NGGLoginSession activeSession].currentUser.bean];
    _homeLabel.text = _gameModel.homeName;
    _awayLabel.text = _gameModel.awayName;
    _dateLabel.text = [JYCommonTool dateFormatWithInterval:_gameModel.startTime.integerValue format:@"MM月dd日 HH:mm开赛"];
    
//    比赛状态，0未开赛 1取消 2关闭 3完结 4赛果录入 5彩果计算完毕;ps：3之后都算比赛结束
    NSInteger status = _gameModel.status.integerValue;
    _statusLabel.text = status == 0 ? @"未开赛" :
                      status == 1 ? @"取消" :
                      status == 2 ? @"关闭" :
                      status == 3 ? @"完结" : @"比赛结束";

}

- (void)refreshData {
    
    SRReadyState state = [[NGGWebSocketHelper shareHelper] socketStatus];
    if(state == SR_OPEN ){
        
        [self loadDetailInfo];
    } else if (state == SR_CLOSED ||
              state == SR_CLOSING) {
        
        [[NGGWebSocketHelper shareHelper] webSocketOpen];
    }
}

- (void)showMakeOrderView {
    
    NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
    NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[selectedIndexPath.section];
    NGGGuessItemModel *itemModel = sectionModel.arrayOfItem[selectedIndexPath.item];
    [_makeOrderView updateWithItemModel:itemModel sectionModel:sectionModel];
    
    _makeOrderView.hidden = NO;
    _resultView.hidden = YES;
}

- (void)hideMakeOrderView {
    
    _makeOrderView.hidden = YES;
}

- (void)showOrderDoneView {
   
    NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
    if (selectedIndexPath == nil) return;
    NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[selectedIndexPath.section];
    NGGGuessItemModel *itemModel = sectionModel.arrayOfItem[selectedIndexPath.item];
    
    NGGGuessRecordModel *model = nil;
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    NSInteger count = 0;
    NSInteger money = 0;
    CGFloat profit = 0;
    for (NGGGuessRecordModel *guessRecordModel in _arrayOfGuessed) {
        
        if ([guessRecordModel.itemID isEqualToString:itemModel.itemID]) {
            
            count++;
            money += guessRecordModel.money.integerValue;
            profit += guessRecordModel.money.floatValue * guessRecordModel.odds.floatValue;
            model = guessRecordModel;
        }
    }
    NSString *moneyString = @(money).stringValue;
    NSString *profitString = [NSString stringWithFormat:@"%.2f", profit];

    NSDictionary *info = @{
                           @"itemName" : model.itemName,
                           @"odds" : model.odds,
                           @"bean" : currentUser.bean,
                           @"itemSection" : model.sectionName,
                           @"guessCount" : @(count).stringValue,
                           @"money" : moneyString,
                           @"profit" : profitString,
                           };
    [_resultView updateGuessOrderDoneViewWithInfo:info];
    _resultView.hidden = NO;
    _makeOrderView.hidden = YES;
}

- (void)hideOrderDoneView {
    
    _resultView.hidden = YES;
}

- (void)updateGuessRecord {
    
//    uid    string    Y    uid
//    token    string    Y    token
//    match_id    string    Y    比赛id
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.playRecord" parameters:@{@"match_id" : _model.matchID} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            if (_gameModel) {
                
//                "h_name": "里昂",
//                "a_name": "马赛",
//                "match_time": "1513540800",
//                "half_score": "",
//                "score": "",
//                "status": "0",
//                "profit": -10100,
//                "bean_total": 10100,
//                "win_total": 0
                NSArray *scoreArray = [dict arrayForKey:@"score"];
                if ([scoreArray count] > 1) {
                    
                    _gameModel.homeScore = [scoreArray firstObject];
                    _gameModel.awayScore = [scoreArray lastObject];
                } else {
                    
                    _gameModel.homeScore = @"0";
                    _gameModel.awayScore = @"0";
                }
                
                _homeScore.text = _gameModel.homeScore;
                _awayScore.text = _gameModel.awayScore;
                
                _gameModel.status = [dict stringForKey:@"status"];
                _gameModel.profit = [dict floatForKey:@"profit"];
                _gameModel.count = [dict floatForKey:@"bean_total"];
                _gameModel.winCount = [dict floatForKey:@"win_total"];
            }
//            bean = 100;
//            ct = 1513653998;
//            item = "ttg@s4";
//            odds = "5.70";
//            "play_name" = "\U8fdb4\U7403";
//            "play_remark" = "";
//            "play_type" = "\U603b\U8fdb\U7403\U6570";
//            "win_bean" = 0;
            NSArray *guessedArray = [dict arrayForKey:@"record"];
            [_dictionaryOfGuessed removeAllObjects];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSInteger index = 0; index < [guessedArray count]; index++) {
                
                NGGGuessRecordModel *model = [[NGGGuessRecordModel alloc] initWithInfo:guessedArray[index]];
                _dictionaryOfGuessed[model.itemID] = @1;
                [arrayM addObject:model];
            }
            
            _arrayOfGuessed = [arrayM copy];
        }
        
        NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
        [self  refreshUI];
        if (selectedIndexPath) {
            
            [_collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self showOrderDoneView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

#pragma mark - button actions

- (void)pageButtonClicked:(UIButton *) button {
    
    _guessButton.selected = NO;
    _liveButton.selected = NO;
    _analyseButton.selected = NO;
    button.selected = YES;
    
    //红线的移动动画
    CGFloat buttonWidth = (SCREEN_WIDTH - 50) / 3.0;
    CGRect fromRect = _pageSwitchTipsView.frame;
    CGRect toRect = CGRectMake(15 + (buttonWidth + 10) * button.tag, 42, buttonWidth, 3);
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    basicAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    basicAnimation.toValue =  [NSValue valueWithCGRect:toRect];
    [_pageSwitchTipsView pop_addAnimation:basicAnimation forKey:@"move"];
}

- (void)moreBeanButtonClicked:(UIButton *)button {
    
    NGGRechargeViewController *controller = [[NGGRechargeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];}

- (void)recordButtonClicked:(UIButton *) button {
    
    NGGGuessRecordViewController *controller = [[NGGGuessRecordViewController alloc] initWithNibName:@"NGGGuessRecordViewController" bundle:nil];
    controller.arrayOfRecord = _arrayOfGuessed;
    controller.gameModel = _gameModel;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)helpButtonClicked:(UIButton *) button {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [_gameModel.arrayOfSection count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[section];
    return [sectionModel.arrayOfItem count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[indexPath.section];
    NGGGuessItemModel *itemModel = sectionModel.arrayOfItem [indexPath.item];
    itemModel.guessable = YES;
    if (_dictionaryOfGuessed[itemModel.itemID]) {
        itemModel.isGuessed = YES;
    } else {
        
        itemModel.isGuessed = NO;
    }
    
    if (sectionModel.itemCellType == NGGGuessDetailCellTypeNormal) {
        
        NGGGuessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuessCellIdentifier forIndexPath:indexPath];
        cell.model = itemModel;
        return cell;
    } else if (sectionModel.itemCellType == NGGGuessDetailCellType2Rows) {
        
        NGGGuess2RowsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuess2RowsCellIdentifier forIndexPath:indexPath];
        cell.model = itemModel;
        return cell;
    } else {

        NGGGuessDescriptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDescriptionCellIdentifier forIndexPath:indexPath];
        cell.model = itemModel;
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        NGGDetailHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderIdentifier forIndexPath:indexPath];
        view.model = _gameModel.arrayOfSection[indexPath.section];
        return view;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[indexPath.section];
    if (sectionModel.itemCellType == NGGGuessDetailCellTypeNormal) {
        
        return  CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
    } else if (sectionModel.itemCellType == NGGGuessDetailCellType2Rows) {
        
        return  CGSizeMake((SCREEN_WIDTH - 50) / 4.0, 40);
    } else {
        
        return  CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
    }
    
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[indexPath.section];
    NGGGuessItemModel *itemModel = sectionModel.arrayOfItem [indexPath.item];
    if (itemModel.isGuessed) {
        
        [self showOrderDoneView];
    } else {
        
        [self showMakeOrderView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - NGGGuessOrderViewDelegate

- (void)guessOrderViewDidClickRechargeButton {
    
    NGGRechargeViewController *controller = [[NGGRechargeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) guessOrderViewMakeOrder:(NSString *)count itemModel:(NGGGuessItemModel *)itemModel sectionModel:(NGGGuessSectionModel *)sectionModel {
    
//    uid    string    Y    uid
//    token    string    Y    token
//    item    string    Y    投注项，详情返回的item
//    match_id    string    Y    比赛id
//    bean    string    Y    投注金豆数，10的倍数
//
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.playGame" parameters:@{@"item" : itemModel.itemID, @"match_id" : _gameModel.matchID, @"bean" : count, @"odds" : itemModel.odds} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            [NGGLoginSession activeSession].currentUser.bean = dict[@"bean"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidModifyUserInfoNotificationName object:nil];
            [self updateGuessRecord];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
    
}

#pragma mark - NGGGuessOrderDoneViewDelegate

-(void)guessOrderDoneViewDidClickAdditionButton {
    
    [self showMakeOrderView];
}

#pragma mark - NGGWebSocketHelperDelegate
//连接成功
- (void)openSuccess {
    
    [self loadDetailInfo];
}
//连接断开
- (void)closeSuccess {
    
}

//无法连接服务器
- (void)connectedFailed {
    
}

- (void)didReceiveData:(id)data {
    
    [self dismissHUD];
    NSData *tmpdata = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:tmpdata options:0 error:nil];
    
    NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
        
        [self showErrorHUDWithText:msg];
    }];
    if (dict) {
        
        if (_gameModel == nil) {///初始化页面数据的时候，加载投注记录
            
            [self updateGuessRecord];
        }
        _gameModel = [[NGGGameModel alloc] initWithInfo:dict];
        [self refreshUI];
    }
}
@end
