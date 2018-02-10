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
#import "NGGGuessListViewController.h"
#import "NGGNavigationController.h"
#import "SCLAlertView.h"
#import "NGGH5GameViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "JYCommonTool.h"
#import "NGGDarenGameViewController.h"

static NSString *kBannerCellIdentifier = @"NGGHomeBannerCollectionViewCell";
static NSString *kPageCellIdentifier = @"NGGHomePageMenuCollectionViewCell";
static NSString *kNoticeCellIdentifier = @"NGGHomeNoticeCollectionViewCell";
static NSString *kActivityHeaderReusableViewIdentifier = @"NGGHomeActivityHeaderReusableView";
static NSString *kItemCellIdentifier = @"NGGHomeItemCollectionViewCell";
static NSString *kHomeHeaderIdentifier = @"NGGHomeHeaderReusableView";

@interface NGGHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
    
    UIImageView *_logoImageView;
    UIImageView *_avatarImageView;
    UILabel *_nicknameLabel;
    UILabel *_coinLabel;
    UILabel *_beanLabel;
    UIImageView *_beanImageView;
}

@property (nonatomic, strong) NSArray *arrayOfNotice;
@property (nonatomic, strong) NSArray *arrayOfBanner;

@end

@implementation NGGHomeViewController

#pragma mark - view life circle

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT + 15, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    if (isIphoneX) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    } else {
        
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT- (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)) collectionViewLayout:flowLayout];
        
    }
    
//    UIView *statusbarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
//    statusbarBG.backgroundColor = NGGPrimaryColor;
    
//    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    visualEffectView.frame = statusbarBG.bounds;
//    visualEffectView.alpha = 0.6;
//    [statusbarBG addSubview:visualEffectView];
//    [self.view addSubview:statusbarBG];
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
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHomePageData)];
    _collectionView.mj_header = header;
    [self.view addSubview:_collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = NGGPrimaryColor;
    [self configureNavigationBar];
    [self refreshHomePageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    
    self.navigationItem.title = nil;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, VIEW_W(titleView) - 110, 50)];

    CGFloat buttonWidth = 45;
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_W(rightView) - buttonWidth, 0, buttonWidth, 50)];
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
    nameLabel.text = @"游客，你好";
    nameLabel.font = [UIFont systemFontOfSize:12];
    _nicknameLabel = nameLabel;
    
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
    goldLabel.text = @"0 ";
    goldLabel.font = [UIFont systemFontOfSize:12];
    _coinLabel = goldLabel;
    
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
    beanLabel.text = @"0 ";
    beanLabel.font = [UIFont systemFontOfSize:12];
    _beanLabel = beanLabel;
    
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
    _beanImageView = beanImageView;
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    [rightView addSubview:avatarImageView];
   
    CGFloat nameWidth = [JYCommonTool calculateStringWidth:_nicknameLabel.text maxSize:CGSizeMake(VIEW_W(titleView) - 250, 20) fontSize:12];
    CGFloat coinWidth = [JYCommonTool calculateStringWidth:_coinLabel.text maxSize:CGSizeMake(VIEW_W(titleView) - 250, 20) fontSize:12];
    CGFloat beanWidth = [JYCommonTool calculateStringWidth:_beanLabel.text maxSize:CGSizeMake(VIEW_W(titleView) - 250, 20) fontSize:12];
    CGFloat bottomWidth = 22 + coinWidth + beanWidth;
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(rightView);
        make.width.mas_equalTo(30);
        if (nameWidth > bottomWidth) {
            
            make.right.equalTo(nameLabel.mas_left).with.offset(-7);
        } else {
            make.right.equalTo(beanImageView.mas_left).with.offset(-7);

        }
    }];
    avatarImageView.image = [UIImage imageNamed:@"avatar_placeholder"];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 15;
    _avatarImageView = avatarImageView;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    logoView.image = [UIImage imageNamed:@"icon"];
    _logoImageView = logoView;
    _logoImageView.hidden = YES;
    
    self.navigationItem.titleView = titleView;
    [titleView addSubview:rightView];
    [titleView addSubview:logoView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshUI];
}

#pragma mark - private methods

- (void)refreshHomePageData {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.index" parameters:nil willContainsLoginSession:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_collectionView.mj_header endRefreshing];
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            _arrayOfBanner = [dict arrayForKey:@"banner"];
            _arrayOfNotice = [dict arrayForKey:@"notice"];
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_collectionView.mj_header endRefreshing];
        [self dismissHUD];
    }];
    
}

- (void)updateUserInfo {
    
    if ([NGGLoginSession activeSession].currentUser) {
        
        [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.userInfo" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self dismissHUD];
            NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
                
                [self showErrorHUDWithText:msg];
            }];
            if (dict) {
                
                NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
                currentUser.uid = dict[@"uid"];
                currentUser.phone = dict[@"phone"];
                currentUser.nickname = dict[@"nickname"];
                currentUser.avatarURL = dict[@"avatar_img"];
                currentUser.sex = dict[@"sex"];
                currentUser.coin = dict[@"coin"];
                currentUser.bean = dict[@"bean"];
                currentUser.point = dict[@"score"];
                currentUser.invitationCode = dict[@"Invite_code"];
                [self refreshUI];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)refreshUI {
    
    [_collectionView reloadData];
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    if (currentUser) {
  
        NSURL *avatarURL = [[NSURL alloc] initWithString:currentUser.avatarURL];
        [_avatarImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _nicknameLabel.text = currentUser.nickname;
        _beanLabel.text = currentUser.bean;
        _coinLabel.text = currentUser.coin;
        
        CGFloat nameWidth = [JYCommonTool calculateStringWidth:_nicknameLabel.text maxSize:CGSizeMake(SCREEN_WIDTH - 280, 20) fontSize:12];
        CGFloat coinWidth = [JYCommonTool calculateStringWidth:_coinLabel.text maxSize:CGSizeMake(SCREEN_WIDTH - 280, 20) fontSize:12];
        CGFloat beanWidth = [JYCommonTool calculateStringWidth:_beanLabel.text maxSize:CGSizeMake(SCREEN_WIDTH - 280, 20) fontSize:12];
        CGFloat bottomWidth = 22 + coinWidth + beanWidth;
        
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
            if (nameWidth > bottomWidth) {
                
                make.right.equalTo(_nicknameLabel.mas_left).with.offset(-7);
            } else {
                make.right.equalTo(_beanImageView.mas_left).with.offset(-7);
                
            }
        }];
    }
}

- (void)bannerImageTapped:(NSInteger)index {
    
    
}

- (void)PageItemTapped:(NSInteger)index {
    
    if (index == 1) {
        
        [self showLoadingHUDWithText:@""];
        NGGGuessListViewController *controller = [[NGGGuessListViewController alloc] initWithNibName:@"NGGGuessListViewController" bundle:nil];
        controller.isLive = YES;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:^{
            
            [self dismissHUD];
        }];
    } else if (index == 2) {
        
        NGGTaskViewController *controller = [[NGGTaskViewController alloc] initWithNibName:@"NGGTaskViewController" bundle:nil];
        [self.tabBarController addChildViewController:controller];
        [self.tabBarController.view  addSubview:controller.view];
    } else if(index == 3) {
        
        NGGDarenGameViewController *controller =  [[NGGDarenGameViewController alloc] initWithNibName:@"NGGDarenGameViewController" bundle:nil];
        NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    } else if (index == 4) {
        
        [self showLoadingHUDWithText:@""];
        NGGGuessListViewController *controller = [[NGGGuessListViewController alloc] initWithNibName:@"NGGGuessListViewController" bundle:nil];
        controller.isLive = NO;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];;
        [self presentViewController:nav animated:YES completion:^{
            
            [self dismissHUD];
        }];
    } else if (index == 5) {
        
        NGGH5GameViewController *controller = [NGGH5GameViewController new];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
    
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
        
        NSMutableArray *arrayM= [NSMutableArray array];
        for(NSInteger index = 0; index < [_arrayOfBanner count]; index++) {

            NSDictionary *noticeDict = _arrayOfBanner[index];
            [arrayM addObject:[noticeDict stringForKey:@"pic"]];
        }
        cell.arrayOfURL = [arrayM copy];

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
        NSMutableArray *arrayM= [NSMutableArray array];
        for(NSInteger index = 0; index < [_arrayOfNotice count]; index++) {
            
            NSDictionary *noticeDict = _arrayOfNotice[index];
            [arrayM addObject:[noticeDict stringForKey:@"notice"]];
        }
        
        cell.arrayOfNotice = [arrayM copy];
        return cell;
    } else if (indexPath.section == 3) {
        
        NGGHomeItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemCellIdentifier forIndexPath:indexPath];
        return cell;
    }


    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
       
         if (indexPath.section == 3) {
            
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
    if (section == 3) {
        
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
