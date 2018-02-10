//
//  NGGRechargeViewController.m
//  Sport
//
//  Created by Jan on 28/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRechargeViewController.h"
#import "NGGRechargeCollectionViewCell.h"
#import "ZSBlockAlertView.h"

static NSString *kRechargeCollectionViewCellidentifier = @"NGGRechargeCollectionViewCell";

@interface NGGRechargeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) NSArray<NGGRechargeModel *> *arrayOfRechargeItem;

@end

@implementation NGGRechargeViewController

#pragma mark - view life circle

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(0.33 * (SCREEN_WIDTH - 45), 150);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    if (isIphoneX) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    } else {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) collectionViewLayout:flowLayout];
    }
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGRechargeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kRechargeCollectionViewCellidentifier];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 20, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configueData];
    self.title = @"充值中心";
    
    if (self.navigationController.viewControllers.count == 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (void)leftBarButtonItemClicked:(UIBarButtonItem *) button {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - private methods

- (void)configueData {
    
    NGGRechargeModel *model_0 = [[NGGRechargeModel alloc] init];
    model_0.ID = @"0";
    model_0.price = @"1";
    model_0.title = @"1金币";
    model_0.image = @"recharge_1";
    
    NGGRechargeModel *model_1 = [[NGGRechargeModel alloc] init];
    model_1.ID = @"1";
    model_1.price = @"12";
    model_1.title = @"12金币";
    model_1.image = @"recharge_12";

    NGGRechargeModel *model_2 = [[NGGRechargeModel alloc] init];
    model_2.ID = @"2";
    model_2.price = @"30";
    model_2.title = @"30金币";
    model_2.image = @"recharge_30";

    NGGRechargeModel *model_3 = [[NGGRechargeModel alloc] init];
    model_3.ID = @"3";
    model_3.price = @"98";
    model_3.title = @"98金币";
    model_3.image = @"recharge_98";

    NGGRechargeModel *model_4 = [[NGGRechargeModel alloc] init];
    model_4.ID = @"4";
    model_4.price = @"308";
    model_4.title = @"308金币";
    model_4.image = @"recharge_308";

    NGGRechargeModel *model_5 = [[NGGRechargeModel alloc] init];
    model_5.ID = @"5";
    model_5.price = @"518";
    model_5.title = @"518金币";
    model_5.image = @"recharge_518";

    NGGRechargeModel *model_6 = [[NGGRechargeModel alloc] init];
    model_6.ID = @"0";
    model_6.price = @"1198";
    model_6.title = @"1198金币";
    model_6.image = @"recharge_1198";

    NGGRechargeModel *model_7 = [[NGGRechargeModel alloc] init];
    model_7.ID = @"7";
    model_7.price = @"2598";
    model_7.title = @"2598金币";
    model_7.image = @"recharge_2598";

    NGGRechargeModel *model_8 = [[NGGRechargeModel alloc] init];
    model_8.ID = @"8";
    model_8.price = @"4998";
    model_8.title = @"4998金币";
    model_8.image = @"recharge_4998";
    
    _arrayOfRechargeItem = @[model_0, model_1, model_2, model_3, model_4, model_5, model_6, model_7, model_8];
    [_collectionView reloadData];
}

- (void)makeOrderWithModel:(NGGRechargeModel *)model {
    
//    [self showLoadingHUDWithText:nil];
////    type    string    Y    支付类型 1微信 2支付宝
////    coin    int    Y    充值金币数
//    NSDictionary *params = @{@"type" : @"1",
//                             @"coin" : model.price,
//                             };
//    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=info.recharge" parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        [self dismissHUD];
//        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
//
//            [self showErrorHUDWithText:msg];
//        }];
//        if (dict) {
//
//            [[NGGSocial sharedInstance] sendWechatPayRequestWithMessage:dict completion:^(NSString *returnKey, NSString *errorMsg) {
//
//                if (errorMsg) {
//
//                    [self showErrorHUDWithText:@"支付失败"];
//                } else {
//
//                    [self showSuccessHUDWithText:@"充值成功，请注意查收" duration:1.0];
//                }
//            }];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        [self dismissHUD];
//    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_arrayOfRechargeItem count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGRechargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRechargeCollectionViewCellidentifier forIndexPath:indexPath];
    cell.model = _arrayOfRechargeItem[indexPath.row];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGRechargeModel *model = _arrayOfRechargeItem[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"确定购买%@", model.title];
    ZSBlockAlertView *alertView = [[ZSBlockAlertView alloc] initWithTitle:title message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
    [alertView setClickHandler:^(NSInteger index) {
        
        if (index == 1) {
            
            [self makeOrderWithModel:model];
        }
    }];
    [alertView show];
}
@end
