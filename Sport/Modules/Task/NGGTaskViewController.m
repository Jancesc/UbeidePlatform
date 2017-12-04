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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
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
    [_closeButton setBackgroundImage:[UIImage imageWithColor:[NGGPrimaryColor colorWithAlphaComponent:0.7]] forState:UIControlStateNormal];
    
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 70.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGTaskTableViewCell" bundle:nil] forCellReuseIdentifier:kTaskCellIdentifier];
    _tableView.hidden = YES;

    [self startLightFlash];
    
    
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
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskCellIdentifier forIndexPath:indexPath];
    return cell;
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
    
    //    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.row == 0)
    //    {
    //        DMAgencyAddBankAccountViewController *controller =
    //        [[DMAgencyAddBankAccountViewController alloc] initWithNibName:@"DMAgencyAddBankAccountViewController" bundle:nil];
    //        controller.delegate = self;
    //        [self.navigationController pushViewController:controller animated:YES];
    //    }
    //    else if (indexPath.row == 1)
    //    {
    //        DMAgencyAddAliPayAccountViewController *contoller = [[DMAgencyAddAliPayAccountViewController alloc] initWithNibName:@"DMAgencyAddAliPayAccountViewController" bundle:nil];
    //        contoller.delegate = self;
    //        [self.navigationController pushViewController:contoller animated:YES];
    //    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
