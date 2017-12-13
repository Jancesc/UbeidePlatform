//
//  NGGLiveGuessDetailViewController.m
//  Sport
//
//  Created by Jan on 11/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGLiveGuessDetailViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import <pop/pop.h>
#import "NGGGuessCollectionViewCell.h"
#import "NGGGuess2RowsCollectionViewCell.h"
#import "NGGDetailHeaderReusableView.h"
#import "NGGDetailAnalyseView.h"
#import "NGGGameModel.h"
#import "NGGWebSocketHelper.h"

static NSString *kGuessCellIdentifier = @"NGGGuessCollectionViewCell";
static NSString *kGuess2RowsCellIdentifier = @"NGGGuess2RowsCollectionViewCell";
static NSString *kDetailHeaderIdentifier = @"NGGDetailHeaderReusableView";

@interface NGGLiveGuessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NGGWebSocketHelperDelegate> {
    
    __weak IBOutlet UIButton *_guessButton;
    __weak IBOutlet UIButton *_liveButton;
    __weak IBOutlet UIButton *_analyseButton;
    __weak IBOutlet UIView *_pageSwitchTipsView;
    __weak IBOutlet UICollectionView *_collectionView;
    WKWebView *_liveWebView;
    __weak IBOutlet UIView *_webviewBG;
    //    http://h5.leida310.com:8079/animation/index.php?id=2163646
}

@property (nonatomic, strong) NGGGameModel *gameModel;

@property (nonatomic, strong) UIView *analyseView;

@end

@implementation NGGLiveGuessDetailViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"赛事";
    [NGGWebSocketHelper shareHelper].delegate = self;;
    [[NGGWebSocketHelper shareHelper] webSocketOpen];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self configueUIComponents];
    SRReadyState state = [[NGGWebSocketHelper shareHelper] socketStatus];
    if (state == SR_OPEN) {
        
        [self loadDetailInfo];
    } else if (state == SR_CLOSED ||
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
    
    [self showLoadingHUDWithText:nil];
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
//    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.gameDetail" parameters:@{@"match_id" : _model.matchID} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        [self dismissHUD];
//        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
//
//            [self showErrorHUDWithText:msg];
//        }];
//        if (dict) {
//
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        [self dismissHUD];
//    }];
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
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGDetailHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = NGGSeparatorColor;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    _analyseView = [[[NSBundle mainBundle] loadNibNamed:@"NGGDetailAnalyseView" owner:nil options:nil] lastObject];
    _analyseView.hidden = YES;
    [self.view addSubview:_analyseView];
    [_analyseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_collectionView.mas_top);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    _liveWebView = [[WKWebView alloc] initWithFrame:_webviewBG.bounds];
    [_liveWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://h5.leida310.com:8079/animation/index.php?id=2163646"]]];
    [_webviewBG addSubview:_liveWebView];
}

- (void)refreshUI {
    
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
    
    if (indexPath.section == 2) {
        
        NGGGuess2RowsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuess2RowsCellIdentifier forIndexPath:indexPath];
        NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[indexPath.section];
        cell.model = sectionModel.arrayOfItem [indexPath.item];
        return cell;
    } else {
        
        NGGGuessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuessCellIdentifier forIndexPath:indexPath];
        NGGGuessSectionModel *sectionModel = _gameModel.arrayOfSection[indexPath.section];
        cell.model = sectionModel.arrayOfItem [indexPath.item];
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        NGGDetailHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderIdentifier forIndexPath:indexPath];
        return view;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return  CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
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
    
    //    NSInteger section = indexPath.section;
    //    NSInteger item = indexPath.item;
    //    NSDictionary *selectedCity = nil;
    //    if (section == 2) {
    //        selectedCity = [_arrayOfRecentCities objectAtIndex:item];
    //    }
    //    else if (section == 3)
    //    {
    //        selectedCity = [_arrayOfServingCities objectAtIndex:item];
    //    }
    //
    //    [self handleSelectCity:selectedCity];
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

