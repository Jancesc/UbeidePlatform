//
//  NGGGuessListViewController.m
//  sport
//
//  Created by Jan on 27/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//
#import "NGGGuessListViewController.h"
#import "NGGPreGuessDetailViewController.h"
#import "NGGGameResultView.h"
#import "Masonry.h"
#import "NGGRankView.h"
#import "NGGGameListView.h"
#import "NGGLiveGuessDetailViewController.h"

@interface NGGGuessListViewController ()<UITableViewDelegate, UITableViewDataSource, NGGGameListViewDelegate, NGGGameResultViewDelegate, NGGRankViewDelegate> {
    
    NGGGameResultView *_resultView;
    NGGRankView *_rankView;
    NGGGameListView *_gameListView;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic)  NSMutableArray *arrayOfGameResult;
@property (strong, nonatomic)  NSDictionary *dictionaryOfRank;

@end

@implementation NGGGuessListViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    if (_isLive) {
        
        self.title = @"滚球竞猜";
        [_segmentControl setTitle:@"滚球" forSegmentAtIndex:0];
    } else {
        
        self.title = @"赛前竞猜";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
    [self refreshUI];
    [self refreshData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserLogined) name:NGGUserDidLoginNotificationName object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleUserLogined {
    
    [self refreshUI];
    [self refreshData];
    _gameListView.superController = self;
}

- (void)configueUIComponents {
    
    self.navigationController.navigationBar.hidden = NO;
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGSeparatorColor] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    
    _gameListView = [[[NSBundle mainBundle] loadNibNamed:@"NGGGameListView" owner:nil options:nil] lastObject];
    _gameListView.hidden = NO;
    _gameListView.backgroundColor = [UIColor whiteColor];
    _gameListView.delegate = self;
    _gameListView.superController = self;
    [self.view addSubview:_gameListView];
    [_gameListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_segmentControl.superview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _resultView = [NGGGameResultView new];
    _resultView.backgroundColor = [UIColor whiteColor];
    _resultView.delegate = self;
    _resultView.hidden = YES;
    [self.view addSubview:_resultView];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_segmentControl.superview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _rankView = [NGGRankView new];
    _rankView.delegate = self;
    _rankView.hidden = YES;
    _rankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rankView];
    [_rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_segmentControl.superview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - private methods

- (void)leftBarButtonClicked {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)refreshUI {
    
    NSInteger index = _segmentControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            _gameListView.hidden = NO;
            _resultView.hidden = YES;
            _rankView.hidden = YES;
            break;
        case 1:
            _gameListView.hidden = YES;
            _resultView.hidden = NO;
            _rankView.hidden = YES;
            _resultView.arrayOfGameResult = _arrayOfGameResult;
            if (_arrayOfGameResult == nil) {
                
                [self loadGameResult];
            }
            break;
        case 2:
            _gameListView.hidden = YES;
            _resultView.hidden = YES;
            _rankView.hidden = NO;
            _rankView.rankDict = _dictionaryOfRank;
            if (_dictionaryOfRank == nil) {
                
                [self loadGameRank];
            }
            break;
    }
}

- (void)refreshData {
    
    NSInteger index = _segmentControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            break;
        case 1:
            [self loadGameResult];
            break;
        case 2:
            [self loadGameRank];
            break;
    }
}


- (void)loadGameResult {
    
    NSInteger page = (NSInteger)([_arrayOfGameResult count] / NGGMaxCountPerPage) + 1;
    if (page == 1) {
        
    }
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.gameResult" parameters:@{@"page" : @(page)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            if (_arrayOfGameResult == nil) {
                
                _arrayOfGameResult = [NSMutableArray arrayWithCapacity:[dataArray count]];
            }
            [_arrayOfGameResult addObjectsFromArray:dataArray];
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)loadGameRank {
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=game.ranking" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _dictionaryOfRank = dict;
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)segmentControlValueChanged:(UISegmentedControl *) segmentControl {

    [self refreshUI];
}

#pragma mark - NGGGameListViewDelegate

- (void)gameListViewDidSelectCellWithModel:(NGGGameListModel *)model {
    
    if (_isLive) {
        
        NSInteger currentTimeStamp = [[NSDate date] timeIntervalSince1970];
        NSInteger gameTimeStamp = model.timeString.integerValue;
        if (gameTimeStamp - currentTimeStamp > 4 * 60) {
            
            [self showErrorHUDWithText:@"比赛未开始" duration:0.75];
            return;
        }
        NGGLiveGuessDetailViewController *controller  = [[NGGLiveGuessDetailViewController alloc] initWithNibName:@"NGGLiveGuessDetailViewController" bundle:nil];
        controller.model = model;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        
        NGGPreGuessDetailViewController *controller =  [[NGGPreGuessDetailViewController alloc] initWithNibName:@"NGGPreGuessDetailViewController" bundle:nil];
        controller.model = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - NGGGameResultViewDelegate

- (void)loadMoreGameResultInfo {
    
    [self loadGameResult];
}

- (void)refreshGameResultInfo {
    
    _arrayOfGameResult = nil;
    [self loadGameResult];
}

#pragma mark - NGGRankViewDelegate

- (void)refreshRankInfo {
    
    [self loadGameRank];
}

@end
