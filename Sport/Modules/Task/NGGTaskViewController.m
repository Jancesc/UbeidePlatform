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

static NSString *kTaskCellIdentifier = @"NGGTaskTableViewCell";

static NSArray *kArrayOfTask;
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
    
    __weak IBOutlet UIButton *_pointDrawButton;
    __weak IBOutlet UIButton *_beanDrawButton;
    CADisplayLink *_displayLink;
    NSInteger _animationFactor;
    NSInteger _aniIndex;
    
    UIView *_coverView;
    CGFloat _point;
    CGFloat _bean;
}

@property (nonatomic, strong) NSArray *arrayOfLotteryButton;
@property (nonatomic, strong) NSArray *arrayOfLotteryItem;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self dismissDisplayLink];
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

    _coverView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    _coverView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRewordView)];
    [_rewordView addGestureRecognizer:tapGestureRecognizer];

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
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.task" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
        
            _point = [dict floatForKey:@"score"];
            _bean = [dict floatForKey:@"bean"];
            kArrayOfTask = [dict arrayForKey:@"list"];
            [self refreshUI];
            [self loadLotteryItems];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
        [self dismissHUD];
    }];
}

/*
@{
     @"image" : @"wwww.image.baidu.com",
     @"title" : @"1000积分",
 }
 */

- (void)showRewordView:(NSDictionary *)rewordInfo{
   
    if (rewordInfo) {
        
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
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.turntable" parameters:nil willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _point = [dict floatForKey:@"score"];
            _bean = [dict floatForKey:@"bean"];
            NSArray *dataArray = [dict arrayForKey:@"list"];
            _arrayOfLotteryItem = dataArray;
            [self refreshUI];
    }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)updatePointAndBean {
    
    
    NSString *beanString = [JYCommonTool stringDisposeWithFloat:_bean];
    NSString *pointString = [JYCommonTool stringDisposeWithFloat:_point];
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

#pragma mark - 开始绘制

-(void)startDisplayLink {
    
    if (_displayLink == nil) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(lotteryAnimation:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes]; /*将_CADisplayLink加入到RunLoop里面之后，selector就会被周期性的调用*/
        _aniIndex = 0;
        _animationFactor = 36;
        kCurrentButtonIndex = 0;
        for (UIButton *button in _arrayOfLotteryButton) {
            
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        UIButton *firstButton = [_arrayOfLotteryButton firstObject];
        [firstButton setBackgroundImage:[UIImage imageNamed:@"active"] forState:UIControlStateNormal];
    }
    [self.view addSubview:_coverView];
}

static NSInteger kCurrentButtonIndex = 0;

- (void)lotteryAnimation:(id) sender {
    
    _aniIndex++;
    if (_aniIndex % _animationFactor == 0) {
        
        UIButton *preButton = _arrayOfLotteryButton[kCurrentButtonIndex % 14];
        [preButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        kCurrentButtonIndex++;
        
        UIButton *button =  _arrayOfLotteryButton[kCurrentButtonIndex % 14];
        [button setBackgroundImage:[UIImage imageNamed:@"active"] forState:UIControlStateNormal];
        
        if (kCurrentButtonIndex == 3) {
            
            _animationFactor = 24;
        } else if (kCurrentButtonIndex == 8) {
            
            _animationFactor = 16;
        } else if (kCurrentButtonIndex == 13) {
            
            _animationFactor = 10;
        } else if (kCurrentButtonIndex == 20) {
            
            _animationFactor = 6;
        } else if (kCurrentButtonIndex == 35) {
            
            _animationFactor = 2;
            [self luckyDraw];
        }
    }
}

- (void)dismissDisplayLink {
    
    [_displayLink invalidate];
    _displayLink = nil;
    [_coverView removeFromSuperview];
}

- (void)showSelectedLottery:(NSInteger)selectedIndex {
    
    UIButton *preButton = _arrayOfLotteryButton[kCurrentButtonIndex % 14];
    [preButton setBackgroundImage:nil forState:UIControlStateNormal];
 
    UIButton *button =  _arrayOfLotteryButton[selectedIndex % 14];
    [button setBackgroundImage:[UIImage imageNamed:@"active"] forState:UIControlStateNormal];
}

- (void)luckyDraw {
    
//    类型，免费抽奖：type=0或空；积分抽奖：type=1；金豆抽奖：type=2

    NSString *type = @"1";
    if (_beanDrawButton.selected) {
        
        type = @"2";
    }
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=home.LuckyDraw" parameters:@{@"type" : type} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self dismissDisplayLink];
            [self showAlertText:msg completion:^{
            
            }];
        }];
        if (dict) {
            
            NSString *selectedID = [dict stringForKey:@"id"];
            for (NSInteger index = 0; index < [_arrayOfLotteryItem count]; index++) {
                
                NSDictionary *itemInfo = _arrayOfLotteryItem[index];
                if ([[itemInfo stringForKey:@"id"] isEqualToString:selectedID]) {
                    
                    [self dismissDisplayLink];
                    [self showSelectedLottery:index];
                    
                    _point = [dict floatForKey:@"score"];
                    _bean = [dict floatForKey:@"bean"];
                    NSDictionary *rewordInfo = @{
                                                 @"title" : [dict stringForKey:@"title"],
                                                 @"image" : [itemInfo stringForKey:@"icon"],
                                                 };
                    [self showRewordView:rewordInfo];
                }
            }
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
        [self loadTaskInfo];
    } else {
        
        _lotteryView.hidden = NO;
        _tableView.hidden = YES;
    }
}

- (void)lotteryButtonClicked:(UIButton *) button {
 
    if ([button isEqual:_beanDrawButton]) {
        
        if (_bean < 100) {
            
            [self showAlertText:@"金豆不足" completion:nil];
            return;
        } else {
            
            _bean -= 100;
        }
    } else {
        
        if (_point < 1000) {
            
            [self showAlertText:@"积分不足" completion:nil];
            return;
        } else {
            
            _point -= 1000;
        }
    }
    
    [self updatePointAndBean];
    _pointButton.selected = NO;
    _beanButton.selected = NO;
    button.selected = YES;
    [self startDisplayLink];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [kArrayOfTask count];;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGGTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = kArrayOfTask[indexPath.row];
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
    
    [self showRewordView:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
