//
//  NGGHomeViewController.m
//  sport
//
//  Created by Jan on 25/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGHomeViewController.h"
#import "Masonry.h"
#import "NGGHomeBannerCollectionViewCell.h"
#import "NGGHomePageMenuCollectionViewCell.h"
#import "MJRefresh.h"
#import "NGGHomeNoticeCollectionViewCell.h"
#import "NGGHomeActivityHeaderReusableView.h"
#import "NGGHomeItemCollectionViewCell.h"
#import "NGGHomeHeaderReusableView.h"
#import "NGGTaskViewController.h"
#import "NGGPreGuessListViewController.h"
#import "NGGNavigationController.h"

static NSString *kBannerCellIdentifier = @"NGGHomeBannerCollectionViewCell";
static NSString *kPageCellIdentifier = @"NGGHomePageMenuCollectionViewCell";
static NSString *kNoticeCellIdentifier = @"NGGHomeNoticeCollectionViewCell";
static NSString *kActivityHeaderReusableViewIdentifier = @"NGGHomeActivityHeaderReusableView";
static NSString *kItemCellIdentifier = @"NGGHomeItemCollectionViewCell";
static NSString *kHomeHeaderIdentifier = @"NGGHomeHeaderReusableView";

@interface NGGHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collectionView;
    UIPageControl *_pageControl;
    UILabel *_noticelabel;
    UIView *_networkFailedView;
    UICollectionViewFlowLayout *_flowLayout;
}

@end

@implementation NGGHomeViewController

#pragma mark - view life circle

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    if (isIphoneX) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    } else {
        
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT) collectionViewLayout:flowLayout];
        
    }
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGHomeBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBannerCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGHomePageMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPageCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGHomeNoticeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kNoticeCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGHomeItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kItemCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGHomeActivityHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kActivityHeaderReusableViewIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGHomeHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeHeaderIdentifier];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = NGGPrimaryColor;
//    [self configureNavigationBar];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    
    self.navigationItem.title = nil;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 44)];
//    rightView.backgroundColor = NGGRandomColor;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *rightFixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    rightFixedSpace.width = -15;
    self.navigationItem.rightBarButtonItems = @[rightFixedSpace,rightBarButton];

    CGFloat buttonWidth = 45;
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_W(rightView) - buttonWidth, 0, buttonWidth, 44)];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightView addSubview:shareButton];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [rightView addSubview:nameLabel];

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(rightView).with.offset(2);
        make.right.equalTo(shareButton.mas_left).with.offset(-5);
        make.width.mas_equalTo(5).with.priority(800);
        make.height.mas_equalTo(20);
    }];
    [nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.text = @"游客6930000000065";
    nameLabel.font = [UIFont systemFontOfSize:12];

    UILabel *goldLabel = [[UILabel alloc] init];
    [rightView addSubview:goldLabel];
    [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(-2);
        make.right.equalTo(shareButton.mas_left).with.offset(-5);
        make.width.mas_equalTo(5).with.priority(800);
        make.height.mas_equalTo(20);
    }];
    [goldLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    goldLabel.textColor = [UIColor whiteColor];
    goldLabel.textAlignment = NSTextAlignmentRight;
    goldLabel.text = @"50";
    goldLabel.font = [UIFont systemFontOfSize:12];
    
    UIImageView *goldImageView = [[UIImageView alloc] init];
    [rightView addSubview:goldImageView];
    [goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(-2);
        make.right.equalTo(goldLabel.mas_left).with.offset(-1);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(20);
    }];
    goldImageView.contentMode = UIViewContentModeScaleAspectFit;
    goldImageView.image = [UIImage imageNamed:@"home_gold"];
    
    UILabel *beanLabel = [[UILabel alloc] init];
    [rightView addSubview:beanLabel];
    [beanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(-2);
        make.right.equalTo(goldImageView.mas_left).with.offset(-5);
        make.width.mas_equalTo(5).with.priority(800);
        make.height.mas_equalTo(20);
    }];
    [beanLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    beanLabel.textColor = [UIColor whiteColor];
    beanLabel.textAlignment = NSTextAlignmentRight;
    beanLabel.text = @"1200000";
    beanLabel.font = [UIFont systemFontOfSize:12];
    
    UIImageView *beanImageView = [[UIImageView alloc] init];
    [rightView addSubview:beanImageView];
    [beanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(-2);
        make.right.equalTo(beanLabel.mas_left).with.offset(-1);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(20);
    }];
    beanImageView.contentMode = UIViewContentModeScaleAspectFit;
    beanImageView.image = [UIImage imageNamed:@"home_bean"];

    UIImageView *avatarImageView = [[UIImageView alloc] init];
    [rightView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(rightView);
        make.width.mas_equalTo(30);
        if (nameLabel.text.length > (beanLabel.text.length + goldLabel.text.length + 3)) {
            
            make.right.equalTo(nameLabel.mas_left).with.offset(-7);
        } else {
            make.right.equalTo(beanImageView.mas_left).with.offset(-7);

        }
    }];
    avatarImageView.image = [UIImage imageNamed:@"avatar_placeholder"];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 15;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    logoView.image = [UIImage imageNamed:@"icon"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoView];;
}

//-(BOOL)prefersStatusBarHidden {
//    
//    return YES;
//}

#pragma mark - private methods

- (void)bannerImageTapped:(NSInteger)index {
    
    
}

- (void)PageItemTapped:(NSInteger)index {
    
    if (index == 1) {
        


    } else if (index == 2) {
        
        NGGTaskViewController *controller = [[NGGTaskViewController alloc] initWithNibName:@"NGGTaskViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (index == 4) {
        
        [self showLoadingHUDWithText:@""];
        NGGPreGuessListViewController *controller = [[NGGPreGuessListViewController alloc] initWithNibName:@"NGGPreGuessListViewController" bundle:nil];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];;
        [self presentViewController:nav animated:YES completion:^{
            
            [self dismissHUD];
        }];
    }
    
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 3) {
        
        return 4;
    }
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        NGGHomeBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellIdentifier forIndexPath:indexPath];
        cell.arrayOfURL = @[@"http://att.bbs.duowan.com/forum/month_0907/20090716_0548c4e0d479a47db1119C2GlGesPGeH.jpg",
                            @"http://img.61gequ.com/allimg/170227/149516-1F22G62045230.jpg"];
        
        NGGWeakSelf
        cell.imageTappedHandler = ^(NSInteger index) {
            
            
            [weakSelf bannerImageTapped:index];
        };
        
        return cell;
    } else if (indexPath.section == 1) {
        
        NGGHomePageMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageCellIdentifier forIndexPath:indexPath];
        
        NGGWeakSelf
        cell.pageTappedHandler = ^(NSInteger index) {
            
            [weakSelf PageItemTapped:index];
        };
        return cell;
    } else if (indexPath.section == 2) {
        
        NGGHomeNoticeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNoticeCellIdentifier forIndexPath:indexPath];
        cell.arrayOfNotice = @[@"http://att.bbs.duowan.com/forum/month_0907/20090716_0548c4e0d479a47db1119C2GlGesPGeH.jpg",
                               @"http://img.61gequ.com/allimg/170227/149516-1F22G62045230.jpg"];
        return cell;
    } else if (indexPath.section == 3) {
        
        NGGHomeItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemCellIdentifier forIndexPath:indexPath];
        return cell;
    }


    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
       
        if (indexPath.section == 0) {
            
            NGGHomeHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeHeaderIdentifier forIndexPath:indexPath];
            return view;
        }
        else if (indexPath.section == 3) {
            
            NGGHomeActivityHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kActivityHeaderReusableViewIdentifier forIndexPath:indexPath];
            return view;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 167.f);
    }
    else if (indexPath.section == 1)
    {
        return CGSizeMake(SCREEN_WIDTH, 230);
    }
    else if (indexPath.section == 2)
    {
        return CGSizeMake(SCREEN_WIDTH, 35);
    }
    else if (indexPath.section == 3)
    {
        return CGSizeMake(0.5 * (SCREEN_WIDTH - 35), 0.32 * (SCREEN_WIDTH - 35) + 30);
    }
    return CGSizeMake(SCREEN_WIDTH, 0);
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(SCREEN_WIDTH, 50);
    } else  if (section == 3) {
        
         return CGSizeMake(SCREEN_WIDTH, 40);
    }
//    else if (section == 1)
//    {
//        return CGSizeMake(SCREEN_WIDTH, [DMLBSCurrentLocationReusableView rowHeight]);
//    }
//    else if (section == 2 || section == 3)
//    {
//        return CGSizeMake(SCREEN_WIDTH, [DMLBSCitySelectionHeaderReusableView rowHeight]);
//    }
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if (section == 1 && section == 2) {
//        return CGSizeMake(SCREEN_WIDTH, 50.f);
//    }
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}


- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 3) {
        
        return UIEdgeInsetsMake(0, 10, 15, 10);
    }
    return UIEdgeInsetsZero;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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

@end
