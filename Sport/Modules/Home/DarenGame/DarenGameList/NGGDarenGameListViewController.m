//
//  NGGDarenGameListViewController.m
//  Sport
//
//  Created by Jan on 07/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameListViewController.h"
#import "NGGDarenGameListTableViewCell.h"

static NSString *kDarenGameListTableViewCellIdentifier = @"darenGameListTableViewCellIdentifier";

@interface NGGDarenGameListViewController ()<UITableViewDelegate, UITableViewDataSource,NGGDarenGameListTableViewCellDelegate> {
    
    UITableView *_tableView;
    NSTimer *_timer;
}

@property (nonatomic, strong) NSMutableArray *arrayOfGameList;

@end

@implementation NGGDarenGameListViewController

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, SCREEN_HEIGHT - 134)];
    [self configueUIComponents];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.view.frame = SCREEN_BOUNDS;
    [self loadData];
}
- (void)clear {
    
    if (_timer) {
        
        [_timer invalidate];
    }
}
#pragma mark - private methods

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 205.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGDarenGameListTableViewCell" bundle:nil] forCellReuseIdentifier:kDarenGameListTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_tableView];
    
    if (_timer) {
        
        [_timer invalidate];
    }
    NGGWeakSelf
    _timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(countTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)loadData {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=expert.expertList" parameters:@{@"page" : @0} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _arrayOfGameList = [[dict arrayForKey:@"list"] mutableCopy];
            [_tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUD];
    }];
    
}

- (void)countTime {
    
    NSArray *cellArray = [_tableView visibleCells];
    
    for (NGGDarenGameListTableViewCell *cell in cellArray) {
        
        [cell countTime];
    }
}

#pragma mark - NGGDarenGameListTableViewCellDelegate

- (void)gameListTableViewcellDidFinishCountDown:(NGGDarenGameListTableViewCell *)cell {
    
    [_arrayOfGameList removeObject:cell.cellInfo];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource    

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfGameList count];;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGDarenGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDarenGameListTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfGameList[indexPath.row];
    cell.delegate = self;
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
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
