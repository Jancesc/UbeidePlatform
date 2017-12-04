//
//  NGGGameListView.m
//  Sport
//
//  Created by Jan on 30/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameListView.h"
#import "NGGDateListView.h"
#import "NGGTypeTableViewCell.h"
#import "NGGPreGameTableViewCell.h"

static NSString *kTypeCellIdentifier = @"NGGTypeTableViewCell";
static NSString *kGameCellIdentifier = @"NGGGameTableViewCell";

@interface NGGGameListView ()<UITableViewDelegate, UITableViewDataSource, NGGDateListViewDelegate> {
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (weak, nonatomic) IBOutlet UITableView *gameTableView;
@property (weak, nonatomic) IBOutlet NGGDateListView *dateScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTableViewWidthConstraint;

@property (nonatomic, assign) NSInteger leagueSelectedIndex;
@property (nonatomic, assign) NSInteger dateSelectedindex;

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
    
    _dateScrollView.listViewdelegate = self;
}

- (void)setDictionaryOfGameList:(NSDictionary *)dictionaryOfGameList {

    _dictionaryOfGameList = dictionaryOfGameList;
    [self refrshData];
}

- (void)refreshUI {
    
    _dateScrollView.arrayOfDate = _arrayOfDate;
    [_typeTableView reloadData];
    [_gameTableView reloadData];
}

- (void)refrshData {
    
    if (_dictionaryOfGameList == nil) {//数据为零
        
        _arrayOfGame = nil;
        _arrayOfLeague = nil;
        _arrayOfDate = nil;
        _dateSelectedindex = -1;
        _leagueSelectedIndex = -1;
        [self refreshUI];
    } else {
        
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
        NGGGameDateModel *dateAllModel = [[NGGGameDateModel alloc] init];
        dateAllModel.dateName = @"全部";
        dateAllModel.count = @(allGame).stringValue;
        [dateArrayM insertObject:dateAllModel atIndex:0];
        _arrayOfDate = [dateArrayM copy];
        
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:[gameListArray count]];
        for (NSInteger index = 0; index < [gameListArray count]; index++) {
            
            NGGGameListModel *gameModel = [[NGGGameListModel alloc] initWithInfo:gameListArray[index]];
            [arrayM addObject:gameModel];
        }
        _arrayOfGame = [arrayM copy];
        
        arrayM =  [NSMutableArray arrayWithCapacity:[leagueListArray count]];
        for (NSInteger index = 0; index < [leagueListArray count]; index++) {
            
            NGGLeagueModel *leagueModel = [[NGGLeagueModel alloc] initWithInfo:leagueListArray[index]];
            [arrayM addObject:leagueModel];
        }
        _arrayOfLeague = [arrayM copy];

        [self refreshUI];
    }
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

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 70.f;
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NGGGuessDetailViewController *controller = [[NGGGuessDetailViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
//    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - NGGDateListViewDelegate

- (void)dateListViewDidSelectItem:(NSDictionary *)itemInfo atIndex:(NSInteger)index {
    
//    if (_delegate && _delegate respondsToSelector:@selector(gameListViewDidSelectDate:)) {
//
//
//    }
}
@end
