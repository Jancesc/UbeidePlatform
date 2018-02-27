//
//  NGGRecordViewController.m
//  Sport
//
//  Created by Jan on 28/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRecordViewController.h"
#import "NGGRecordTableViewCell.h"
#import "MJRefresh.h"
#import "NGGGuessRecordViewController.h"
static NSString *kRecordTableViewCellIdentifier = @"kRecordTableViewCellIdentifier";

@interface NGGRecordViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UISegmentedControl *_segmentControl;
    __weak IBOutlet UITableView *_tableView;
    
}

@property (nonatomic, strong) NSMutableArray *arrayOfPreRecord;
@property (nonatomic, strong) NSMutableArray *arrayOfLiveRecord;
@property (nonatomic, strong) NSMutableArray *arrayOfDarenGame;


@end

@implementation NGGRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"竞猜记录";
    [self configueUIComponents];
    [self loadRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)configueUIComponents {
    
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
    if (_fromDarenGame) {
        
        _segmentControl.selectedSegmentIndex = 2;
    }
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 130.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGRecordTableViewCell" bundle:nil] forCellReuseIdentifier:kRecordTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}

- (void)refreshUI {
    
    [_tableView reloadData];
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfPreRecord :
                     _segmentControl.selectedSegmentIndex == 1 ? _arrayOfLiveRecord : _arrayOfDarenGame;
    NSInteger arrayCount = [array count];
    if (arrayCount == 0) {
        
        [self showEmptyViewInView:_tableView];
    } else {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self dismissEmptyView];
    }
    
    if (arrayCount > 0 && arrayCount % NGGMaxCountPerPage == 0) {
        
        [self setupLoadMoreFooter];
    } else {
        
        _tableView.mj_footer = nil;
    }
}

- (void)loadRecord {
    
    [self showLoadingHUDWithText:nil];
    NSDictionary *params = @{@"type" : @(_segmentControl.selectedSegmentIndex + 1)};

    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.playRecord" parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            if (_segmentControl.selectedSegmentIndex == 0) {
                
                _arrayOfPreRecord = [dataArray mutableCopy];
            } else if (_segmentControl.selectedSegmentIndex == 1) {
                
                _arrayOfLiveRecord = [dataArray mutableCopy];
            } else {
                
                _arrayOfDarenGame = [dataArray mutableCopy];
            }
        }
        [self refreshUI];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)loadMoreData {
    
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfPreRecord :
                     _segmentControl.selectedSegmentIndex == 1 ? _arrayOfLiveRecord : _arrayOfDarenGame;
    NSInteger page = (NSInteger)([array count] / NGGMaxCountPerPage) + 1;
    NSDictionary *params = @{@"type" : @(_segmentControl.selectedSegmentIndex + 1), @"page" : @(page)};
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.playRecord" parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            if (_segmentControl.selectedSegmentIndex == 0) {
                
                [_arrayOfPreRecord addObjectsFromArray: dataArray];
            } else if(_segmentControl.selectedSegmentIndex == 1) {
                
                [_arrayOfLiveRecord addObjectsFromArray: dataArray];
            } else {
                
                [_arrayOfDarenGame addObjectsFromArray:dataArray];
            }
        }
        
        [_tableView reloadData];
        if ([dataArray count] < NGGMaxCountPerPage) {
            
            _tableView.mj_footer = nil;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}


#pragma mark - button actions

- (void)segmentControlValueChanged:(UISegmentedControl *) segmentControl {
    
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfPreRecord :
                     _segmentControl.selectedSegmentIndex == 1 ? _arrayOfLiveRecord : _arrayOfDarenGame;
    if(array == nil) {
        
        [self loadRecord];
    }else {
      
        [self refreshUI];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfPreRecord :
                     _segmentControl.selectedSegmentIndex == 1 ? _arrayOfLiveRecord : _arrayOfDarenGame;
    return [array count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellIdentifier forIndexPath:indexPath];
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfPreRecord :
                     _segmentControl.selectedSegmentIndex == 1 ? _arrayOfLiveRecord : _arrayOfDarenGame;
    cell.cellInfo = array[indexPath.row];
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
    NGGGuessRecordViewController *controller = [[NGGGuessRecordViewController alloc] initWithNibName:@"NGGGuessRecordViewController" bundle:nil];
    NSArray *array = _segmentControl.selectedSegmentIndex == 0 ? _arrayOfPreRecord :
                     _segmentControl.selectedSegmentIndex == 1 ? _arrayOfLiveRecord : _arrayOfDarenGame;
    NSDictionary *cellInfo = array[indexPath.row];
    controller.gameType = _segmentControl.selectedSegmentIndex + 1;
    controller.gameID = [cellInfo stringForKey:@"match_id"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
