//
//  NGGTaskViewController.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTaskViewController.h"
#import "NGGTaskTableViewCell.h"
#import <pop/pop.h>

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
    __weak IBOutlet UIButton *_button_0;
}

@end

@implementation NGGTaskViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = SCREEN_BOUNDS;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self setupUIComponents];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _tableView.rowHeight = 70.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGTaskTableViewCell" bundle:nil] forCellReuseIdentifier:kTaskCellIdentifier];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    _tableView.hidden = YES;

    [self startLightFlash];
    _lotteryView.hidden = YES;
    _tableView.hidden = NO;
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
        NSArray *dataArray = [self arrayData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dataArray) {
            
            kArrayOfTask = dataArray;
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
        [self dismissHUD];
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
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
