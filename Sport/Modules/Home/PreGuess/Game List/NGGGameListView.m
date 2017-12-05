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
@property (nonatomic, strong) NSArray *arrayOfDate;

@end

@implementation NGGGameListView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self configueUIComponents];
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

- (void)setDictionaryOfGameList:(NSDictionary *)dictionaryOfGameList {

    _dictionaryOfGameList = dictionaryOfGameList;
    if (_arrayOfDate == nil) {//初始化
        
        [self initData];
    } else {
        
        [self refreshData];
    }
}

- (void)refreshUI {
    
    NSIndexPath *typeSelectedIndexPath = [_typeTableView indexPathForSelectedRow];
    if (typeSelectedIndexPath == nil) {
        
        typeSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [_typeTableView reloadData];
    [_gameTableView reloadData];

    if ([_arrayOfLeague count] > 0) {

        [_typeTableView selectRowAtIndexPath:typeSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [_typeTableView cellForRowAtIndexPath:typeSelectedIndexPath];
        [cell setSelected:YES animated:NO];
    }
}

///初始化日期数据以及联赛数据
- (void)initData {
    
    if (_dictionaryOfGameList == nil) return;
        
    NSArray *gameListArray = [_dictionaryOfGameList arrayForKey:@"list"];
    NSArray *leagueListArray = [_dictionaryOfGameList arrayForKey:@"classify"];
    NSArray *dateArray = [_dictionaryOfGameList arrayForKey:@"date"];
    
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
        [leagueArrayM insertObject:leagueAllModel atIndex:0];
    }
    _arrayOfLeague = [leagueArrayM copy];
    
    NSMutableArray *gameArrayM = [NSMutableArray arrayWithCapacity:[gameListArray count]];
    
    for (NSInteger index = 0; index < [gameListArray count]; index++) {
        
        NGGGameListModel *gameModel = [[NGGGameListModel alloc] initWithInfo:gameListArray[index]];
        [gameArrayM addObject:gameModel];
    }
    _arrayOfGame = [gameArrayM copy];
    [self initFreshUI];
}

- (void)initFreshUI {

    [_typeTableView reloadData];
    [_gameTableView reloadData];
    [_dateCollectionView reloadData];
    
    if ([_arrayOfLeague count] > 0) {
        
        [_typeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [_typeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setSelected:YES animated:NO];
    }
    
    if ([_arrayOfDate count] > 0) {
        
        [_dateCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)refreshData {
    
    NSArray *gameListArray = [_dictionaryOfGameList arrayForKey:@"list"];
    NSArray *leagueListArray = [_dictionaryOfGameList arrayForKey:@"classify"];
    NSMutableArray *leagueArrayM = [NSMutableArray arrayWithCapacity:[leagueListArray count]];
    for (NSInteger index = 0; index < [leagueListArray count]; index++) {
        
        NGGLeagueModel *leagueModel = [[NGGLeagueModel alloc] initWithInfo:leagueListArray[index]];
        [leagueArrayM addObject:leagueModel];
    }
    if ([leagueArrayM count] > 0) {
        
        NGGLeagueModel *leagueAllModel = [[NGGLeagueModel alloc] init];
        leagueAllModel.leagueName = @"所有联赛";
        [leagueArrayM insertObject:leagueAllModel atIndex:0];
    }
    _arrayOfLeague = [leagueArrayM copy];
    
    NSMutableArray *gameArrayM = [NSMutableArray arrayWithCapacity:[gameListArray count]];
    
    for (NSInteger index = 0; index < [gameListArray count]; index++) {
        
        NGGGameListModel *gameModel = [[NGGGameListModel alloc] initWithInfo:gameListArray[index]];
        [gameArrayM addObject:gameModel];
    }
    _arrayOfGame = [gameArrayM copy];
    
    [self refreshUI];
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
    return 0.01f;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_typeTableView]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(gameListViewUpdateInfoWithLeagueID:timeStamp:)]) {
            
            NSIndexPath *selectedDateIndexPath = [[_dateCollectionView indexPathsForSelectedItems] firstObject];
            NGGGameDateModel *model = _arrayOfDate[selectedDateIndexPath.item];
            NSString *timeStamp = model.timeStamp;
            if (timeStamp == nil) {//全部 为空
                
                timeStamp = @"0";
            }
            NGGLeagueModel *leagueModel = _arrayOfLeague[indexPath.row];
            NSString *leagueID = leagueModel.leagueID;
            if (leagueID == nil) {//全部为空
                
                leagueID = @"0";
            }
            [_delegate gameListViewUpdateInfoWithLeagueID:leagueID timeStamp:timeStamp];
        }
    } else if ([tableView isEqual:_gameTableView]) {
        
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
    
    NGGGameDateModel *model = _arrayOfDate[indexPath.row];
    if (_arrayOfLeague.count > 0) {
        
        [_typeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(gameListViewUpdateInfoWithLeagueID:timeStamp:)]) {
        
        NSString *timeStamp = model.timeStamp;
        if (timeStamp == nil) {
            
            timeStamp = @"0";
        }
        [_delegate gameListViewUpdateInfoWithLeagueID:@"0" timeStamp:timeStamp];
    }
}

@end
