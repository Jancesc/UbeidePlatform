//
//  NGGTaskViewController.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTaskViewController.h"
#import "NGGTaskTableViewCell.h"
#import "POP.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "JYCommonTool.h"
#import "NGGRechargeViewController.h"
#import "NGGExchangeViewController.h"
#import "NGGGuessListViewController.h"
#import "NGGNavigationController.h"

static NSString *kLastFreeDrawKey = @"lastFreeDrawKey";

static NSString *kTaskCellIdentifier = @"NGGTaskTableViewCell";

@interface NGGTaskViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UIView *_taskView;
    __weak IBOutlet UIButton *_closeButton;
    __weak IBOutlet UIButton *_pointButton;
    __weak IBOutlet UIButton *_beanButton;
    __weak IBOutlet UISegmentedControl *_segmentControl;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIView *_lotteryView;
    __weak IBOutlet UIImageView *_lotteryFlashView;
   
    __weak IBOutlet UIView *_rewordView;
    __weak IBOutlet UIImageView *_rewordAniImageView;
    __weak IBOutlet UILabel *_rewordDescLabel;
    __weak IBOutlet UIView *_rewordAniBGview;
    __weak IBOutlet UIImageView *_rewordImageView;
    
    __weak IBOutlet UIButton *_lotteryButton_0;
    __weak IBOutlet UIButton *_lotteryButton_1;
    __weak IBOutlet UIButton *_lotteryButton_2;
    __weak IBOutlet UIButton *_lotteryButton_3;
    __weak IBOutlet UIButton *_lotteryButton_4;
    __weak IBOutlet UIButton *_lotteryButton_5;
    __weak IBOutlet UIButton *_lotteryButton_6;
    __weak IBOutlet UIButton *_lotteryButton_7;
    __weak IBOutlet UIButton *_lotteryButton_8;
    __weak IBOutlet UIButton *_lotteryButton_9;
    __weak IBOutlet UIButton *_lotteryButton_10;
    __weak IBOutlet UIButton *_lotteryButton_11;
    __weak IBOutlet UIButton *_lotteryButton_12;
    __weak IBOutlet UIButton *_lotteryButton_13;
    
    __weak IBOutlet UIImageView *_lotteryCoverView;
    
    __weak IBOutlet UIButton *_freeDrawButton;
    __weak IBOutlet UIButton *_pointDrawButton;
    __weak IBOutlet UIButton *_beanDrawButton;
    CADisplayLink *_displayLink;
    NSInteger _animationFactor;
    NSInteger _aniIndex;

    UIView *_coverView;
    NSDictionary *_rewordDict;
    
    
     NSInteger _currentButtonIndex;
    
     NSInteger _selectedIndex;
     BOOL _openPrizeState;
}

@property (nonatomic, strong) NSArray *arrayOfLotteryButton;
@property (nonatomic, strong) NSArray *arrayOfLotteryItem;
@property (nonatomic, strong) NSMutableArray *arrayOfTask;

@end

@implementation NGGTaskViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = SCREEN_BOUNDS;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    _arrayOfLotteryButton = @[_lotteryButton_0, _lotteryButton_1, _lotteryButton_2, _lotteryButton_3,
                              _lotteryButton_4, _lotteryButton_5, _lotteryButton_6, _lotteryButton_7,
                              _lotteryButton_8, _lotteryButton_9, _lotteryButton_10, _lotteryButton_11,
                              _lotteryButton_12, _lotteryButton_13];
    
    [self setupUIComponents];
    [self loadTaskInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserLogined) name:NGGUserDidLoginNotificationName object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self dismissDisplayLink];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUIComponents {
    
    _taskView.layer.cornerRadius = 10.f;
    _taskView.layer.masksToBounds = YES;
    _taskView.layer.borderWidth = 2.f;
    _taskView.layer.borderColor = [NGGPrimaryColor CGColor];
    
    _closeButton.layer.cornerRadius = 0.05 *  SCREEN_WIDTH;
    _closeButton.clipsToBounds = YES;
    _closeButton.layer.borderWidth = 1.f;
    _closeButton.layer.borderColor = [NGGPrimaryColor CGColor];
    [_closeButton setBackgroundImage:[UIImage imageWithColor:[NGGPrimaryColor colorWithAlphaComponent:0.85]] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    [_segmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    
    _tableView.separatorColor = NGGColorCCC;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 80.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGTaskTableViewCell" bundle:nil] forCellReuseIdentifier:kTaskCellIdentifier];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    _tableView.hidden = YES;

    [self startLightFlash];
    _lotteryView.hidden = YES;
    _tableView.hidden = NO;
    
    _rewordView.backgroundColor = UIColorWithRGBA(0x00, 0x000, 0x00, 230);
    _rewordAniBGview.backgroundColor = [UIColor clearColor];
    _rewordDescLabel.textColor = NGGViceColor;
    _rewordView.hidden = YES;
    
    _pointDrawButton.layer.cornerRadius = 0.5 * VIEW_H(_pointDrawButton);
    _pointDrawButton.clipsToBounds = YES;
    _beanDrawButton.layer.cornerRadius = 0.5 * VIEW_H(_beanDrawButton);
    _beanDrawButton.clipsToBounds = YES;
    
    [_pointDrawButton setBackgroundImage:[UIImage imageWithColor:NGGThirdColor] forState:UIControlStateNormal];
    _pointDrawButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_pointDrawButton addTarget:self action:@selector(lotteryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    [_beanDrawButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    _beanDrawButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_beanDrawButton addTarget:self action:@selector(lotteryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [_freeDrawButton addTarget:self action:@selector(freeDrawButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self shouldShowFreeDrawButton]) {
        
        _freeDrawButton.hidden = NO;
        _beanDrawButton.hidden = YES;
        _pointDrawButton.hidden = YES;
    } else {
        
        _freeDrawButton.hidden = YES;
        _beanDrawButton.hidden = NO;
        _pointDrawButton.hidden = NO;
    }
    
    _coverView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    _coverView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRewordView)];
    [_rewordView addGestureRecognizer:tapGestureRecognizer];

    UIButton *firstButton = [_arrayOfLotteryButton firstObject];

    _lotteryCoverView.frame = CGRectMake(0, 0, 1.5*VIEW_W(firstButton), 1.5 * VIEW_H(firstButton));
    _lotteryCoverView.center = firstButton.center;
}

#pragma mark - private methods

- (BOOL)shouldShowFreeDrawButton {
    
    NSInteger LastDrawInterval = [[NSUserDefaults standardUserDefaults] integerForKey:kLastFreeDrawKey];
    NSInteger currentInterval = [[NSDate date] timeIntervalSince1970];
    NSString *LastDrawDateString = [JYCommonTool dateFormatWithInterval:LastDrawInterval format:@"yyyy-MM-dd"];
    NSString *currentDateString = [JYCommonTool dateFormatWithInterval:currentInterval format:@"yyyy-MM-dd"];
    return ![LastDrawDateString isEqualToString:currentDateString];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

static UIImage *image_0, *image_1;

- (void)startLightFlash {

    if (!image_0 || !image_1) {
        
        image_0 = [UIImage imageNamed:@"shine_0"];
        image_1 = [UIImage imageNamed:@"shine_1"];
    }

    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"flash" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            
            UIImageView *imageView = (UIImageView *)obj;
            NSInteger index = (NSInteger)values[0];
            if (index % 2) {
                
                imageView.image = image_1;
            } else {
                imageView.image = image_0;
            }
        };
        prop.threshold = 0.6;
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(0);
    anBasic.toValue = @(1000000);
    anBasic.duration = 600000;
    anBasic.beginTime = CACurrentMediaTime();    //延迟1秒开始
    [_lotteryFlashView pop_addAnimation:anBasic forKey:@"flash"];
}

- (void)stopLightFlash {
    
}

- (void)loadTaskInfo {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.task" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            [NGGLoginSession activeSession].currentUser.point = [dict stringForKey:@"score"];
            [NGGLoginSession activeSession].currentUser.bean = [dict stringForKey:@"bean"];

            _arrayOfTask = [[dict arrayForKey:@"list"] mutableCopy];;
            [self refreshUI];
            [self loadLotteryItems];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
        [self dismissAnimationLoadingHUD];
    }];
}

/*
@{
     @"image" : @"wwww.image.baidu.com",
     @"title" : @"1000积分",
 }
 */

- (void)showRewordView:(NSDictionary *)rewordInfo{
   
    if (_segmentControl.selectedSegmentIndex == 0) {//任务
        NSInteger rewordType = [rewordInfo intForKey:@"award_type"];//奖励类型，1积分 2金豆
        if (rewordType == 1) {
            
            _rewordImageView.image = [UIImage imageNamed:@"reword_point"];
            _rewordDescLabel.text = [NSString stringWithFormat:@"%@积分", [rewordInfo stringForKey:@"quantity"]];
        } else {
            
            _rewordImageView.image = [UIImage imageNamed:@"reword_bean"];
            _rewordDescLabel.text = [NSString stringWithFormat:@"%@金币", [rewordInfo stringForKey:@"quantity"]];
        }
    } else {//抽奖
        
        [_rewordImageView sd_setImageWithURL:[NSURL URLWithString:[rewordInfo stringForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _rewordDescLabel.text = [rewordInfo stringForKey:@"title"];
    }
    _rewordView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _rewordView.alpha = 0.0;
    _rewordView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
       
        _rewordView.alpha = 1.0;
        _rewordView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    
        CABasicAnimation *rotationAnimation;
        
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        
        rotationAnimation.duration = 7.0;
        
        rotationAnimation.cumulative = NO;
        
        rotationAnimation.repeatCount = HUGE_VAL;
        
        [_rewordAniImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }];
}

- (void)dismissRewordView {
    
    _rewordView.hidden = YES;
    [_rewordAniImageView.layer removeAllAnimations];
}

- (void)loadLotteryItems {
    
    [self dismissAnimationLoadingHUD];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.turntable" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            [NGGLoginSession activeSession].currentUser.point = [dict stringForKey:@"score"];
            [NGGLoginSession activeSession].currentUser.bean = [dict stringForKey:@"bean"];
            NSArray *dataArray = [dict arrayForKey:@"list"];
            _arrayOfLotteryItem = dataArray;
            [self refreshUI];
    }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUD];
    }];
}

- (void)updatePointAndBean {
    
    
    NSString *beanString = [JYCommonTool stringDisposeWithFloat:[NGGLoginSession activeSession].currentUser.bean.floatValue];
    NSString *pointString = [JYCommonTool stringDisposeWithFloat:[NGGLoginSession activeSession].currentUser.point.floatValue];
    [_beanButton setTitle:beanString forState:UIControlStateNormal];
    [_pointButton setTitle:pointString forState:UIControlStateNormal];
}

- (void)refreshUI {
   
    [self updatePointAndBean];
    for (NSInteger index = 0; index < [_arrayOfLotteryItem count]; index++) {
        
        UIButton *button = _arrayOfLotteryButton[index];
        NSDictionary *info = _arrayOfLotteryItem[index];
        [button sd_setImageWithURL:[NSURL URLWithString:[info stringForKey:@"icon"]] forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)getReword:(NSDictionary *)rewordInfo {
    
    [self showAnimationLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.reward" parameters:@{@"task_id" : [rewordInfo stringForKey:@"id"]} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissAnimationLoadingHUD];
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
           
            [NGGLoginSession activeSession].currentUser.bean = [dict stringForKey:@"bean"];
            [NGGLoginSession activeSession].currentUser.point = [dict stringForKey:@"score"];
            
            NSMutableDictionary *rewordInfoM = [rewordInfo mutableCopy];
            rewordInfoM[@"status"] = @"2";
            [_arrayOfTask removeObject:rewordInfo];
            [_arrayOfTask insertObject:[rewordInfoM copy] atIndex:0];
            [self refreshUI];
            [self showRewordView:rewordInfoM];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissAnimationLoadingHUD];
    }];
}

- (void)jumpToTargetViewController:(NSInteger)taskType {

    //类任务型，1每日签到 2每日充值 3每日投注 4每日兑换
    switch (taskType) {
        case 2: {
            
            NGGRechargeViewController *controller = [[NGGRechargeViewController alloc] init];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];;
            [self.parentViewController presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 3: {
            NGGGuessListViewController *controller = [[NGGGuessListViewController alloc] initWithNibName:@"NGGGuessListViewController" bundle:nil];
            controller.isLive = NO;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];;
            [self.parentViewController presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 4: {
          
            NGGExchangeViewController *controller = [[NGGExchangeViewController alloc] initWithNibName:@"NGGExchangeViewController" bundle:nil];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];;
            [self.parentViewController presentViewController:nav animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)handleUserLogined {
    
    [self loadTaskInfo];
}
#pragma mark - 开始绘制

-(void)startDisplayLink {
    
    if (_displayLink == nil) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(lotteryAnimation:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes]; /*将_CADisplayLink加入到RunLoop里面之后，selector就会被周期性的调用*/
        _aniIndex = 0;
        _animationFactor = 2;
        _currentButtonIndex = 0;
        _selectedIndex = -1;
        _openPrizeState = NO;
        for (UIButton *button in _arrayOfLotteryButton) {
            
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        UIButton *firstButton = [_arrayOfLotteryButton firstObject];
        _lotteryCoverView.frame = CGRectMake(0, 0, 1.5*VIEW_W(firstButton), 1.5 * VIEW_H(firstButton));
        _lotteryCoverView.center = firstButton.center;
    }
    [self.view addSubview:_coverView];
}

- (void)lotteryAnimation:(id) sender {
    
    _aniIndex++;
    if (_aniIndex % _animationFactor == 0) {
        
        UIButton *preButton = _arrayOfLotteryButton[_currentButtonIndex % 14];
        [preButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        _currentButtonIndex++;
        
        UIButton *button =  _arrayOfLotteryButton[_currentButtonIndex % 14];
        _lotteryCoverView.frame = CGRectMake(0, 0, 1.5*VIEW_W(button), 1.5 * VIEW_H(button));
        _lotteryCoverView.center = button.center;
        if (_currentButtonIndex == 30) {
            
            _animationFactor = 2;
            [self luckyDraw];
        }
        
        if (_selectedIndex >= 0 && _openPrizeState == NO && _currentButtonIndex % 14 == _selectedIndex) {//判断进入开奖动画
            
            _openPrizeState = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 _animationFactor = 4;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _animationFactor = 7;
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _animationFactor = 13;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _animationFactor = 20;
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _animationFactor = 30;
            });
        }
        
        if (_animationFactor == 30 && _currentButtonIndex % 14 == _selectedIndex) {
            
            [self dismissDisplayLink];
                    
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                [self refreshUI];
                NSDictionary *itemInfo = _arrayOfLotteryItem[_selectedIndex];
                NSDictionary *rewordInfo = @{
                                               @"title" : [_rewordDict stringForKey:@"title"],
                                               @"image" : [itemInfo stringForKey:@"icon"],
                                            };
                [self showRewordView:rewordInfo];
                });
        }
    }
}
- (void)slowAnimationToShowPrize:(NSDictionary *)dict {
    
    _rewordDict = dict;
    NSString *selectedID = [dict stringForKey:@"id"];
    for (NSInteger index = 0; index < [_arrayOfLotteryItem count]; index++) {
        
        NSDictionary *itemInfo = _arrayOfLotteryItem[index];
        if ([[itemInfo stringForKey:@"id"] isEqualToString:selectedID]) {
            
            [NGGLoginSession activeSession].currentUser.point = [dict stringForKey:@"score"];
            [NGGLoginSession activeSession].currentUser.bean = [dict stringForKey:@"bean"];
            _selectedIndex = index;
            if (_beanDrawButton.hidden && _pointDrawButton.hidden) {
                
                _pointDrawButton.hidden = NO;
                _beanDrawButton.hidden = NO;
                _freeDrawButton.hidden = YES;
                [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSince1970] forKey:kLastFreeDrawKey];
            }
            
        }
    }
}

- (void)dismissDisplayLink {
    
    [_displayLink invalidate];
    _displayLink = nil;
    [_coverView removeFromSuperview];
}

- (void)showSelectedLottery:(NSInteger)selectedIndex {
    
    UIButton *preButton = _arrayOfLotteryButton[_currentButtonIndex % 14];
    [preButton setBackgroundImage:nil forState:UIControlStateNormal];
 
    UIButton *button =  _arrayOfLotteryButton[selectedIndex % 14];
    _lotteryCoverView.frame = CGRectMake(0, 0, 1.5*VIEW_W(button), 1.5 * VIEW_H(button));
    _lotteryCoverView.center = button.center;
}

- (void)luckyDraw {
    
//    类型，免费抽奖：type=0或空；积分抽奖：type=1；金豆抽奖：type=2

    NSString *type = @"0";
    
    if (_beanDrawButton.selected) {
        
        type = @"2";
    } else {
        
        type = @"1";
    }
    
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.LuckyDraw" parameters:@{@"type" : type} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            if (code == 605) {//当前已经免费投注过了
                _pointDrawButton.hidden = NO;
                _beanDrawButton.hidden = NO;
                _freeDrawButton.hidden = YES;
                
                [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSince1970] forKey:kLastFreeDrawKey];
            }
            [self dismissDisplayLink];
            [self showAlertText:msg completion:^{
            
            }];
        }];
        if (dict) {
           
            [self slowAnimationToShowPrize:dict];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



#pragma mark - button actions

- (void)closeButtonClicked:(UIButton *) button {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)segmentControlValueChanged:(UISegmentedControl *) segmentControl {
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        _lotteryView.hidden = YES;
        _tableView.hidden = NO;
    } else {
        
        _lotteryView.hidden = NO;
        _tableView.hidden = YES;
    }
}

- (void)lotteryButtonClicked:(UIButton *) button {
    
    CGFloat point = [NGGLoginSession activeSession].currentUser.point.floatValue;
    CGFloat bean = [NGGLoginSession activeSession].currentUser.bean.floatValue;
    if ([button isEqual:_beanDrawButton]) {
        
        if (bean < 100) {
            
            [self showAlertText:@"金豆不足" completion:nil];
            return;
        } else {
            
            bean -= 100;
            [NGGLoginSession activeSession].currentUser.bean = [JYCommonTool stringDisposeWithFloat:bean];
        }
    } else {
        
        if (point < 1000) {
            
            [self showAlertText:@"积分不足" completion:nil];
            return;
        } else {
            
            point -= 1000;
            [NGGLoginSession activeSession].currentUser.point = [JYCommonTool stringDisposeWithFloat:point];
        }
    }
    
    [self updatePointAndBean];
    _pointButton.selected = NO;
    _beanButton.selected = NO;
    button.selected = YES;
    [self startDisplayLink];
}

- (void)freeDrawButtonClicked:(UIButton *) button {
    
    [self startDisplayLink];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfTask count];;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGGTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfTask[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    seperator.backgroundColor = NGGColorCCC;
    return seperator;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *cellInfo = _arrayOfTask[indexPath.row];
    NSInteger status = [cellInfo intForKey:@"status"];
    switch (status) {
            
        case 0: {//未完成
            
            NSInteger type = [cellInfo intForKey:@"type"];//类任务型，1每日签到 2每日充值 3每日投注 4每日兑换
            [self jumpToTargetViewController:type];
            break;
        }
        case 1: {//可领取
            
            [self getReword:cellInfo];
            break;
        }
        case 2: {//已领取
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
