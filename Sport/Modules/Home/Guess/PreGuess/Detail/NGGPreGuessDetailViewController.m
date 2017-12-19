//
//  NGGPreGuessDetailViewController.m
//  sport
//
//  Created by Jan on 06/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGPreGuessDetailViewController.h"
#import "Masonry.h"
#import <pop/pop.h>
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

static NSString *kGuessCellIdentifier = @"NGGGuessCollectionViewCell";
static NSString *kGuess2RowsCellIdentifier = @"NGGGuess2RowsCollectionViewCell";
static NSString *kDescriptionCellIdentifier = @"NGGDescriptionCellIdentifier";
static NSString *kDetailHeaderIdentifier = @"NGGDetailHeaderReusableView";

@interface NGGPreGuessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NGGWebSocketHelperDelegate, NGGGuessOrderViewDelegate> {
    
    __weak IBOutlet UIButton *_guessButton;
    __weak IBOutlet UIButton *_liveButton;
    __weak IBOutlet UIButton *_analyseButton;
    __weak IBOutlet UIView *_pageSwitchTipsView;
    __weak IBOutlet UICollectionView *_collectionView;
    
    NGGGuessOrderView *_makeOrderView;
    NGGGuessOrderDoneView *_resultView;
}

@property (nonatomic, strong) NGGGameModel *gameModel;
@property (nonatomic, strong) UIView *analyseView;

@end

@implementation NGGPreGuessDetailViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"赛前";
    [self configueUIComponents];
    [NGGWebSocketHelper shareHelper].delegate = self;;
    [[NGGWebSocketHelper shareHelper] webSocketOpen];
    [NSUserDefaults standardUserDefaults];
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
    
    [NGGWebSocketHelper shareHelper].delegate = nil;
    [[NGGWebSocketHelper shareHelper] webSocketClose];
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
}

- (void)refreshUI {
    
    [_collectionView reloadData];
    [_collectionView.mj_header endRefreshing];
    
    [self hideMakeOrderView];
    [self hideOrderDoneView];
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
    
    
}

- (void)hideOrderDoneView {
    
    [self showLoadingHUDWithText:nil];
}

- (void)updateGuessRecord {
    
//    uid    string    Y    uid
//    token    string    Y    token
//    match_id    string    Y    比赛id
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.playRecord" parameters:@{@"match_id" : _gameModel.matchID} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
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
    if (sectionModel.itemCellType == NGGGuessDetailCellTypeNormal) {
        
        NGGGuessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuessCellIdentifier forIndexPath:indexPath];
        NGGGuessItemModel *model = sectionModel.arrayOfItem [indexPath.item];
        model.isGuessed = YES;
        cell.model = model;
        return cell;
    } else if (sectionModel.itemCellType == NGGGuessDetailCellType2Rows) {
        
        NGGGuess2RowsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuess2RowsCellIdentifier forIndexPath:indexPath];
        cell.model = sectionModel.arrayOfItem [indexPath.item];
        return cell;
    } else {

        NGGGuessDescriptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDescriptionCellIdentifier forIndexPath:indexPath];
        cell.model = sectionModel.arrayOfItem [indexPath.item];
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
    [self showMakeOrderView];
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
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.playGame" parameters:@{@"item" : itemModel.itemID, @"match_id" : _gameModel.matchID, @"bean" : count} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BOOL success = [self noData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (success) {
            
            [self updateGuessRecord];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
    
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
        
        _gameModel = [[NGGGameModel alloc] initWithInfo:dict];
        [self refreshUI];
    }
}
@end
