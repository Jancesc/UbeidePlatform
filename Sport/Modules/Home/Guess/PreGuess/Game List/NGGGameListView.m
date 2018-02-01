//
//  NGGGameListView.m
//  Sport
//
//  Created by Jan on 30/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameListView.h"
#import "NGGTypeTableViewCell.h"
#import "NGGPreGameTableViewCell.h"
#import "NGGDateCollectionViewCell.h"
#import "MJRefresh.h"

static NSString *kTypeCellIdentifier = @"NGGTypeTableViewCell";
static NSString *kGameCellIdentifier = @"NGGGameTableViewCell";
static NSString *kGameDateCellIdentifier = @"NGGGameDateCell";

@interface NGGGameListView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource> {
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (weak, nonatomic) IBOutlet UITableView *gameTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTableViewWidthConstraint;

@property (nonatomic, strong) NSArray<NGGLeagueModel *> *arrayOfLeague;
@property (nonatomic, strong) NSArray<NGGGameListModel *> *arrayOfGame;
@property (nonatomic, strong) NSArray<NGGGameDateModel *> *arrayOfDate;

@property (nonatomic, strong) NSString *stringOfURL;

@end

@implementation NGGGameListView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self configueUIComponents];
}

- (void)setSuperController:(NGGGuessListViewController *)superController {
    
    _superController = superController;
    if (_superController.isLive) {
        
        _stringOfURL = @"/api.php?method=live.gameList";
    } else {
        
        _stringOfURL = @"/api.php?method=game.gameList";
    }
    
    [self loadDateInfo];
}

#pragma mark - private methods

- (void)configueUIComponents {
  
    _typeTableView.separatorColor = NGGColorCCC;
    [_typeTableView setSeparatorInset:UIEdgeInsetsZero];
    _typeTableView.backgroundColor = [UIColor clearColor];
    _typeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _typeTableView.rowHeight = 50.f;
    _typeTableView.delegate = self;
    _typeTableView.dataSource = self;
    _typeTableView.layer.borderColor = [NGGSeparatorColor CGColor];
    _typeTableView.layer.borderWidth = 0.5f;
    _typeTableView.showsVerticalScrollIndicator = NO;
    [_typeTableView registerNib:[UINib nibWithNibName:@"NGGTypeTableViewCell" bundle:nil] forCellReuseIdentifier:kTypeCellIdentifier];
    
    _gameTableView.separatorColor = NGGColorCCC;
    _gameTableView.backgroundColor = [UIColor clearColor];
    _gameTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _gameTableView.rowHeight = 144.f;
    _gameTableView.delegate = self;
    _gameTableView.dataSource = self;
    [_gameTableView registerNib:[UINib nibWithNibName:@"NGGPreGameTableViewCell" bundle:nil] forCellReuseIdentifier:kGameCellIdentifier];
    _typeTableViewWidthConstraint.constant = 125.0 * SCREEN_WIDTH / 375;
    
    _dateCollectionView.delegate = self;
    _dateCollectionView.dataSource = self;
    [_dateCollectionView registerNib:[UINib nibWithNibName:@"NGGDateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGameDateCellIdentifier];
}

///刷新日期数据以及联赛数据
- (void)loadDateInfo {
    
    NSDictionary *params = nil;
    NSIndexPath *selectedDateIndexPath = [[_dateCollectionView indexPathsForSelectedItems] firstObject];
    if (selectedDateIndexPath) {
        
        NGGGameDateModel *dateModel = _arrayOfDate[selectedDateIndexPath.row];
        params = @{@"mt" : dateModel.timeStamp};
    }
    
    [_superController showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:_stringOfURL parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_superController dismissHUD];
        NSDictionary *dict = [_superController dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [_superController showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            NSArray *gameListArray = [dict arrayForKey:@"list"];
            NSArray *leagueListArray = [dict arrayForKey:@"classify"];
            NSArray *dateArray = [dict arrayForKey:@"date"];
            
            NSMutableArray *dateArrayM = [NSMutableArray arrayWithCapacity:[dateArray count] + 1];
            NSInteger allGame = 0;
            for (NSInteger index = 0; index < [dateArray count]; index++) {
                
                NGGGameDateModel *dateModel = [[NGGGameDateModel alloc] initWithInfo:dateArray[index]];
                allGame += dateModel.count.integerValue;
                [dateArrayM addObject:dateModel];
            }
            if ([dateArray count] > 0) {
                
                NGGGameDateModel *dateAllModel = [[NGGGameDateModel alloc] init];
                dateAllModel.dateName = @"全部";
                dateAllModel.timeStamp = @"0";
                dateAllModel.count = @(allGame).stringValue;
                [dateArrayM insertObject:dateAllModel atIndex:0];
            }
            _arrayOfDate = [dateArrayM copy];
            
            NSMutableArray *leagueArrayM = [NSMutableArray arrayWithCapacity:[leagueListArray count]];
            for (NSInteger index = 0; index < [leagueListArray count]; index++) {
                
                NGGLeagueModel *leagueModel = [[NGGLeagueModel alloc] initWithInfo:leagueListArray[index]];
                [leagueArrayM addObject:leagueModel];
            }
            if ([leagueArrayM count] > 0) {
                
                NGGLeagueModel *leagueAllModel = [[NGGLeagueModel alloc] init];
                leagueAllModel.leagueName = @"所有联赛";
                leagueAllModel.leagueID = @"0";
                [leagueArrayM insertObject:leagueAllModel atIndex:0];
            }
            _arrayOfLeague = [leagueArrayM copy];
            
            NSMutableArray *gameArrayM = [NSMutableArray arrayWithCapacity:[gameListArray count]];
            
            for (NSInteger index = 0; index < [gameListArray count]; index++) {
                
                NGGGameListModel *gameModel = [[NGGGameListModel alloc] initWithInfo:gameListArray[index]];
                [gameArrayM addObject:gameModel];
            }
            _arrayOfGame = [gameArrayM copy];
            [self refreshUIForDateInfo];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_superController dismissHUD];
    }];
}

- (void)refreshUIForDateInfo {
   
    NSIndexPath *selectedDateIndexPath = [[_dateCollectionView indexPathsForSelectedItems] firstObject];
    if (selectedDateIndexPath == nil) {
        
        selectedDateIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    
    [_typeTableView reloadData];
    [_gameTableView reloadData];
    [_dateCollectionView reloadData];
    
    if ([_arrayOfLeague count] > 0) {
        
        [_typeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [_typeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setSelected:YES animated:NO];
    }
    
    if ([_arrayOfDate count] > 0) {
        
        [_dateCollectionView selectItemAtIndexPath:selectedDateIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    if ([_arrayOfGame count] > 0 &&
        [_arrayOfGame count] % NGGMaxCountPerPage == 0) {
        
        [self setupLoadMoreFooter];
    } else {
        
        _gameTableView.mj_footer = nil;
    }
}

- (void)loadTypeInfo {
    
    NSIndexPath *selectedDateIndexPath = [[_dateCollectionView indexPathsForSelectedItems] firstObject];
    NGGGameDateModel *dateModel = _arrayOfDate[selectedDateIndexPath.row];
    
    NSIndexPath *selectedLeagueIndexPath = [_typeTableView indexPathForSelectedRow];
    NGGLeagueModel *leagueModel = _arrayOfLeague[selectedLeagueIndexPath.row];
    
    [_superController showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:_stringOfURL parameters:@{@"mt" : dateModel.timeStamp, @"c_type" : leagueModel.leagueID, @"c_id" : leagueModel.leagueID} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_superController dismissHUD];
        NSDictionary *dict = [_superController dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [_superController showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            ///
            NSArray *gameListArray = [dict arrayForKey:@"list"];
            NSArray *leagueListArray = [dict arrayForKey:@"classify"];
            NSMutableArray *leagueArrayM = [NSMutableArray arrayWithCapacity:[leagueListArray count]];
            for (NSInteger index = 0; index < [leagueListArray count]; index++) {
                
                NGGLeagueModel *leagueModel = [[NGGLeagueModel alloc] initWithInfo:leagueListArray[index]];
                [leagueArrayM addObject:leagueModel];
            }
            if ([leagueArrayM count] > 0) {
                
                NGGLeagueModel *leagueAllModel = [[NGGLeagueModel alloc] init];
                leagueAllModel.leagueName = @"所有联赛";
                leagueAllModel.leagueID = @"0";
                [leagueArrayM insertObject:leagueAllModel atIndex:0];
            }
            _arrayOfLeague = [leagueArrayM copy];
            
            NSMutableArray *gameArrayM = [NSMutableArray arrayWithCapacity:[gameListArray count]];
            
            for (NSInteger index = 0; index < [gameListArray count]; index++) {
                
                NGGGameListModel *gameModel = [[NGGGameListModel alloc] initWithInfo:gameListArray[index]];
                [gameArrayM addObject:gameModel];
            }
            _arrayOfGame = [gameArrayM copy];
            
            [self refreshUIForTypeInfo];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_superController dismissHUD];
    }];

}


- (void)refreshUIForTypeInfo {
    
    NSIndexPath *typeSelectedIndexPath = [_typeTableView indexPathForSelectedRow];
    if (typeSelectedIndexPath == nil) {
        
        typeSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [_typeTableView reloadData];
    [_gameTableView reloadData];
    _gameTableView.contentOffset = CGPointMake(0, 0);
    if ([_arrayOfLeague count] > 0) {
        
        [_typeTableView selectRowAtIndexPath:typeSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [_typeTableView cellForRowAtIndexPath:typeSelectedIndexPath];
        [cell setSelected:YES animated:NO];
    }
    
    if ([_arrayOfGame count] > 0 &&
        [_arrayOfGame count] % NGGMaxCountPerPage == 0) {
        
        [self setupLoadMoreFooter];
    } else {
        
        _gameTableView.mj_footer = nil;
    }
}


- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _gameTableView.mj_footer = footer;
}

- (void)loadMoreData {
    
    NSIndexPath *selectedDateIndexPath = [[_dateCollectionView indexPathsForSelectedItems] firstObject];
    NGGGameDateModel *dateModel = _arrayOfDate[selectedDateIndexPath.item];

    NSIndexPath *selectedLeagueIndexPath = [_typeTableView indexPathForSelectedRow];
    NGGLeagueModel *leagueModel = _arrayOfLeague[selectedLeagueIndexPath.row];
    
    NSInteger page = (NSInteger)([_arrayOfGame count] / NGGMaxCountPerPage) + 1;

    [[NGGHTTPClient defaultClient] postPath:_stringOfURL parameters:@{@"mt" : dateModel.timeStamp, @"c_type" : leagueModel.leagueID, @"c_id" : leagueModel.leagueID, @"page" : @(page)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_gameTableView.mj_footer endRefreshing];
        NSDictionary *dict = [_superController dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [_superController showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            ///
            NSArray *gameListArray = [dict arrayForKey:@"list"];
            NSMutableArray *gameArrayM = [[NSMutableArray alloc] initWithArray:_arrayOfGame];
            for (NSInteger index = 0; index < [gameListArray count]; index++) {
                
                NGGGameListModel *gameModel = [[NGGGameListModel alloc] initWithInfo:gameListArray[index]];
                [gameArrayM addObject:gameModel];
            }
            _arrayOfGame = [gameArrayM copy];
            [_gameTableView reloadData];
            
            if ([gameListArray count] < NGGMaxCountPerPage) {
                
                _gameTableView.mj_footer = nil;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_gameTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:_typeTableView]) {
        
        return [_arrayOfLeague count];
    } else {
     
        return [_arrayOfGame count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_typeTableView]) {
        
        NGGTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTypeCellIdentifier forIndexPath:indexPath];
        cell.model = _arrayOfLeague[indexPath.row];
        return cell;
    }else if ([tableView isEqual:_gameTableView]) {
        
        NGGPreGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameCellIdentifier forIndexPath:indexPath];
        cell.model = _arrayOfGame[indexPath.row];
        return cell;
    }
    return nil;
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
    if ([_gameTableView isEqual:tableView]) {
        
        if ([_arrayOfGame count] > 0) {
            
            return 0.5f;
        }
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if ([_gameTableView isEqual:tableView]) {
        
        if ([_arrayOfGame count] > 0) {
            
            UIView *footerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            footerSeparator.backgroundColor = NGGSeparatorColor;
            return footerSeparator;
        }
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_typeTableView]) {
        
        [self loadTypeInfo];
    } else if ([tableView isEqual:_gameTableView]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NGGGameListModel *model = _arrayOfGame[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(gameListViewDidSelectCellWithModel:)]) {
            
            [_delegate gameListViewDidSelectCellWithModel:model];
        }
    }
}

#pragma mark - UICollectionViewDataSource  && UICollectionViewDelagate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [_arrayOfDate count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGDateCollectionViewCell *cell = [_dateCollectionView dequeueReusableCellWithReuseIdentifier:kGameDateCellIdentifier forIndexPath:indexPath];
    cell.model = _arrayOfDate[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    [self loadDateInfo];
}

@end
