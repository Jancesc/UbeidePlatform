//
//  NGGShopViewController.m
//  Sport
//
//  Created by Jan on 06/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGShopViewController.h"
#import "NGGShopClassifyCollectionViewCell.h"
#import "NGGShopItemCollectionViewCell.h"
#import "MJRefresh.h"
#import "JYCommonTool.h"
#import "NGGEmptyView.h"
#import "NGGGoodsDetailViewController.h"

static NSString *kShopClassifyCellIdentifier = @"shopClassifyCellIdentifier";
static NSString *kShopItemCellIdentifier = @"shopItemCellIdentifier";

@interface NGGShopViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    
    __weak IBOutlet UICollectionView *_classifycollectionView;
    __weak IBOutlet UICollectionView *_itemCollectionView;
}

@property (nonatomic, strong) NSArray *arrayOfClassify;

@property (nonatomic, strong) NSMutableArray *arrayOfGoods;

@end

@implementation NGGShopViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
    
    self.view.backgroundColor = NGGGlobalBGColor;
    
    _classifycollectionView.delegate = self;
    _classifycollectionView.dataSource = self;
    [_classifycollectionView registerNib:[UINib nibWithNibName:@"NGGShopClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kShopClassifyCellIdentifier];
    
    _itemCollectionView.delegate = self;
    _itemCollectionView.dataSource = self;
    [_itemCollectionView registerNib:[UINib nibWithNibName:@"NGGShopItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kShopItemCellIdentifier];
}

#pragma mark - private methods

- (void)refreshUI {
    
    NSIndexPath *selectedClassifyIndexPath = [[_classifycollectionView indexPathsForSelectedItems] firstObject];
    if (selectedClassifyIndexPath == nil && [_arrayOfClassify count] > 0) {
        
        selectedClassifyIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    
    if (selectedClassifyIndexPath.item == 0 && selectedClassifyIndexPath.section == 0) {
        
        [_classifycollectionView reloadData];
        [_classifycollectionView selectItemAtIndexPath:selectedClassifyIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [_itemCollectionView reloadData];
    if ([_arrayOfGoods count] % NGGMaxCountPerPage == 0 && [_arrayOfGoods count] > 0) {
        
        [self setupLoadMoreFooter];
    } else {
        
        _itemCollectionView.mj_footer = nil;
    }
    
    if ([_arrayOfGoods count] == 0) {
        
        [self showEmptyViewInView:_itemCollectionView];
    }
    
    
}

- (void) setupLoadMoreFooter {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _itemCollectionView.mj_footer = footer;
}

- (void)loadData {
    
    NSIndexPath *selectedIndexPath = [[_classifycollectionView indexPathsForSelectedItems] firstObject];
    NSDictionary *selectedClassifyDict = _arrayOfClassify[selectedIndexPath.row];
    NSString *classifyID = [selectedClassifyDict stringForKey:@"id"];
    NSDictionary *params = nil;
    if (!isStringEmpty(classifyID)) {
        
        params = @{@"cid" : classifyID};
    }
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=goods.init" parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _arrayOfGoods = [[dict arrayForKey:@"goods"] mutableCopy];
            NSArray *classifyArray = [dict arrayForKey:@"classify"];
            if ([classifyArray count] > 0) {
                
                NSMutableArray *arrayM = [NSMutableArray array];
                NSDictionary *allDict = @{
                                          @"id": @"0",
                                          @"classify_name": @"全部"
                                          };
                [arrayM addObject:allDict];
                [arrayM addObjectsFromArray:classifyArray];
                _arrayOfClassify = [arrayM copy];
            }
            
            [self refreshUI];
            _itemCollectionView.contentOffset = CGPointZero;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)loadMoreData {
    
    NSInteger page = (NSInteger)([_arrayOfGoods count] / NGGMaxCountPerPage) + 1;
    NSIndexPath *selectedIndexPath = [[_classifycollectionView indexPathsForSelectedItems] firstObject];
    NSDictionary *selectedClassifyDict = _arrayOfClassify[selectedIndexPath.row];
    NSString *classifyID = [selectedClassifyDict stringForKey:@"id"];
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=goods.init" parameters:@{@"cid" : classifyID, @"page" : @(page)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_itemCollectionView.mj_footer endRefreshing];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            NSArray *goodsArray = [dict arrayForKey:@"goods"];
            if ([goodsArray count] != NGGMaxCountPerPage) {
                
                [_itemCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [_arrayOfGoods addObjectsFromArray:goodsArray];
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_itemCollectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - UICollectionViewDataSource  && UICollectionViewDelagate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isEqual:_classifycollectionView]) {
        
        return [_arrayOfClassify count];
    } else  if ([collectionView isEqual:_itemCollectionView]) {

        return [_arrayOfGoods count];
    }
    
    return 0;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:_classifycollectionView]) {
        
        NGGShopClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopClassifyCellIdentifier forIndexPath:indexPath];
        NSDictionary *cellInfo = _arrayOfClassify[indexPath.item];
        cell.cellInfo = cellInfo;
        return cell;
    } else  if ([collectionView isEqual:_itemCollectionView]) {
        
        NGGShopItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopItemCellIdentifier forIndexPath:indexPath];
        NSDictionary *cellInfo = _arrayOfGoods[indexPath.item];
        cell.cellInfo = cellInfo;
        return cell;
    }
    
    return  nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:_classifycollectionView]) {
        
        [self loadData];
    } else  if ([collectionView isEqual:_itemCollectionView]) {
        
        NGGGoodsDetailViewController *controller = [[NGGGoodsDetailViewController alloc] initWithNibName:@"NGGGoodsDetailViewController" bundle:nil];
        controller.goodsInfo = _arrayOfGoods[indexPath.row];         
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:_classifycollectionView]) {
        
        NSDictionary *cellInfo = _arrayOfClassify[indexPath.item];
        NSString *classifyName = [cellInfo stringForKey:@"classify_name"];
        CGFloat itemWidth =  [JYCommonTool calculateStringWidth:classifyName maxSize:CGSizeMake(MAXFLOAT, 44) fontSize:14.f] + 20;
        return CGSizeMake(itemWidth, VIEW_H(collectionView));
    } else  if ([collectionView isEqual:_itemCollectionView]) {
        
        return CGSizeMake(0.5 * (SCREEN_WIDTH - 35), 200);
    }
    
    return CGSizeMake(0, 0);
}
@end

