//
//  NGGCommonViewController.m
//  shelves
//
//  Created by Jan on 08/08/2017.
//  Copyright © 2017 niugaga. All rights reserved.
//

#import "NGGCommonViewController.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "EncodingTools.h"
#import "ZSBlockAlertView.h"
#import "NGGNavigationController.h"
#import "UIImage+Helpers.h"
#import <objc/runtime.h>
#import "NGGHTTPClient.h"
#import "Masonry.h"
#import "NGGLoginViewController.h"
#import "NGGEmptyView.h"

float NGGHudShortDuration = 0.5f;
float NGGHudNormalDuration = 1.0f;
float NGGHudLongDuration = 2.0f;

static const void *kNGGLoadingHUDKey = "kNGGLoadingHUDKey";

#define LOG_DATA(d) NSLog(@"%@", [[NSString alloc] initWithData:(d) encoding:NSUTF8StringEncoding])
#define INDICATOR_ALPHA 0.7f

#define HUDSuccessMessage(msg,d) ([SVProgressHUD showSuccessWithStatus:(msg) duration:(d)])


static NSOperationQueue *sRequestQueue = nil;

@interface NGGCommonViewController ()
{
    UILabel *_loadingLabel;
    UIImageView *_loadingIView;
    
    UILabel *_animationLoadingLabel;
    UIImageView *_animationLoadingIView;
    
    //    UIView *_cover;
    
    
    UIView *_emptyView;
    
}

@end

@implementation NGGCommonViewController

- (instancetype) init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    self.view.backgroundColor = NGGSeparatorColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Message METHODS
- (void)showLoadingHUDWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = text;
}

- (void)dismissHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

- (void)showSuccessHUDWithText:(NSString *)text
{
    [self showSuccessHUDWithText:text duration:NGGHudShortDuration];
}

- (void)showSuccessHUDWithText:(NSString *)text duration:(float)duration
{
    [self dismissHUD];
    HUDSuccessMessage(text, duration);
    [SVProgressHUD showSuccessWithStatus:text];
}

- (void)showErrorHUDWithText:(NSString *)text
{
    [self showErrorHUDWithText:text duration:NGGHudNormalDuration];
}

- (void)showErrorHUDWithText:(NSString *)text duration:(float)duration
{
    [self dismissHUD];
    HUDErrorMessage(text, duration);
}

- (void)showAlertText:(NSString *)text completion:(void (^)(void))completion
{
    ZSBlockAlertView *alert = [[ZSBlockAlertView alloc] initWithTitle:nil message:text cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert setClickHandler:^(NSInteger index) {
        if (completion) {
            completion();
        }
    }];
    [alert show];
}

- (void)showLoadingLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.f)];
    label.userInteractionEnabled = NO;
    label.textColor = UIColorWithRGBA(0, 0, 0, 100);
    label.text = text == nil ? @"加载中..." : text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13.f];
    label.center = CGPointMake(VIEW_W(self.view)*0.5f, VIEW_H(self.view)*0.5f);
    [self.view addSubview:label];
    _loadingLabel = label;
}

- (void)dismissLoadingLabel
{
    if (_loadingLabel.superview)
    {
        [_loadingLabel removeFromSuperview];
    }
    _loadingLabel = nil;
}

- (void)showAnimationLoadingHUDWithText:(NSString *)text
{
    [self showAnimationLoadingHUDWithText:text onView:self.view];
}

- (void)dismissAnimationLoadingHUD
{
    [self dismissAnimationLoadingHUDOnView:self.view];
}

- (void) showAnimationLoadingHUDWithText:(NSString *)text onView:(UIView *) view
{
    NSDictionary *hud = objc_getAssociatedObject(view, kNGGLoadingHUDKey);
    if (!hud) {
        UIImage *indicatorImage = [UIImage imageNamed:@"loading"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.image = [indicatorImage imageWithColor:NGGPrimaryColor];
        imageView.center = CGPointMake(VIEW_W(view)*0.5f, VIEW_H(view)*0.4f);
        CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
        keyAnima.keyPath = @"transform.rotation";
        keyAnima.duration = NGGHudNormalDuration;
        keyAnima.values = @[ @0,@(2 * M_PI)];
        keyAnima.repeatCount = HUGE_VALF;
        keyAnima.fillMode = kCAFillModeForwards;
        keyAnima.removedOnCompletion = NO;
        [imageView.layer addAnimation:keyAnima forKey:nil];
        imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, VIEW_W(view), 13)];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        
        hud = @{@"UILabel":label, @"UIImageView":imageView};
        objc_setAssociatedObject(view, kNGGLoadingHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UIImageView *loadingIView = hud[@"UIImageView"];
    UILabel *loadingLabel = hud[@"UILabel"];
    loadingLabel.text = text;
    
    [view addSubview:loadingIView];
    [view addSubview:loadingLabel];
    
    loadingIView.hidden = YES;
    loadingLabel.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        loadingIView.hidden = NO;
        loadingLabel.hidden = NO;
    });
    
}

- (void) dismissAnimationLoadingHUDOnView:(UIView *) view
{
    NSDictionary *hud = objc_getAssociatedObject(view, kNGGLoadingHUDKey);
    if (!hud) {
        return;
    }
    
    UIImageView *loadingIView = hud[@"UIImageView"];
    UILabel *loadingLabel = hud[@"UILabel"];
    
    if (loadingIView.superview) {
        [loadingIView removeFromSuperview];
    }
    if (loadingLabel.superview) {
        [loadingLabel removeFromSuperview];
    }
    
    objc_setAssociatedObject(view, kNGGLoadingHUDKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - API Reponse

#define CODE_NONLOGIN   401
#define CODE_NOTOKEN    401
#define CODE_TOKENFAIL  402

- (NSDictionary *)dictionaryData:(id)responseJSONObject errorHandler:(void (^)(NSInteger, NSString *))handler
{
    if (![responseJSONObject isKindOfClass:[NSDictionary class]]) {
        handler(-100, @"格式有误");
        return nil;
    }
    NSDictionary *responseDic = responseJSONObject;
    NSInteger state = [[responseDic objectForKey:@"state"] integerValue];
    if (state != 1) {
        NSInteger code = [[responseDic objectForKey:@"code"] integerValue];
        NSString *msg = [responseDic stringForKey:@"msg"];
        
        if (code == CODE_NONLOGIN || code == CODE_NOTOKEN || code == CODE_TOKENFAIL) {
            //处理用户未登录和用户登录TOKEN失效
            [self handleTokenFailed];
        }
        else
        {
            handler(code, msg);
        }
        return nil;
    }
    
    return [responseDic dictionaryForKey:@"data"];
}

- (NSArray *)arrayData:(id)responseJSONObject errorHandler:(void (^)(NSInteger, NSString *))handler
{
    if (![responseJSONObject isKindOfClass:[NSDictionary class]]) {
        handler(-100, @"格式有误");
        return nil;
    }
    NSDictionary *responseDic = responseJSONObject;
    NSInteger state = [[responseDic objectForKey:@"state"] integerValue];
    if (state != 1) {
        NSInteger code = [[responseDic objectForKey:@"code"] integerValue];
        NSString *msg = [responseDic stringForKey:@"msg"];
        
        if (code == CODE_NONLOGIN || code == CODE_NOTOKEN || code == CODE_TOKENFAIL) {
            //处理用户未登录和用户登录TOKEN失效
            [self handleTokenFailed];
        }
        else
        {
            handler(code, msg);
        }
        return nil;
    }
    
    return [responseDic arrayForKey:@"data"];
}

- (BOOL)noData:(id)responseJSONObject errorHandler:(void (^)(NSInteger, NSString *))handler
{
    if (![responseJSONObject isKindOfClass:[NSDictionary class]]) {
        handler(-100, @"格式有误");
        return NO;
    }
    NSDictionary *responseDic = responseJSONObject;
    NSInteger state = [[responseDic objectForKey:@"state"] integerValue];
    if (state != 1) {
        NSInteger code = [[responseDic objectForKey:@"code"] integerValue];
        NSString *msg = [responseDic stringForKey:@"msg"];
        
        if (code == CODE_NONLOGIN || code == CODE_NOTOKEN || code == CODE_TOKENFAIL) {
            //处理用户未登录和用户登录TOKEN失效
            [self handleTokenFailed];
        }
        else
        {
            handler(code, msg);
        }
        
        return NO;
    }
    
    return YES;
}

- (void) handleTokenFailed
{
    [self dismissHUD];
    [self dismissAnimationLoadingHUD];
    [self presentLoginViewControllerWithAlertView];
}

//
-(void)presentLoginViewControllerWithAlertView{
    
    [self.view endEditing:YES];
    [NGGLoginSession destroyActiveSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidLogoutNotificationName object:nil];
    [self showAlertText:@"请您先登录" completion:^{
        
        [self presentLoginViewController];
    }];
    
    
}

-(void)presentLoginViewController{
    
    [self.view endEditing:YES];
    [NGGLoginSession destroyActiveSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidLogoutNotificationName object:nil];
    NGGLoginViewController *controller = [[NGGLoginViewController alloc] init];
    NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if (self.navigationController) {
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    } else {
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)showEmptyViewInView:(UIView *)view {
    
    if (_emptyView == nil) {
        
        _emptyView = [[NGGEmptyView alloc] initWithFrame:view.bounds];
    }
    
    _emptyView.frame = view.bounds;
    [view addSubview:_emptyView];
}

- (void)dismissEmptyView {
    
    if (_emptyView && _emptyView.superview) {
        
        [_emptyView removeFromSuperview];
    }
}

@end
