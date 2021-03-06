//
//  NGGTabBarController.m
//  shelves
//
//  Created by Jan on 07/08/2017.
//  Copyright © 2017 niugaga. All rights reserved.
//

#import "NGGTabBarController.h"
#import "NGGNavigationController.h"
#import "NGGHomeViewController.h"
#import "NGGTaskViewController.h"
#import "NGGUserViewController.h"
#import "NGGShopViewController.h"
#import "NGGNavigationBar.h"

@interface NGGTabBarController ()

@end

@implementation NGGTabBarController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods

- (void)configure {

    NGGHomeViewController *homeVC = [[NGGHomeViewController alloc] init];
    NGGNavigationController *homeNav = [[NGGNavigationController alloc] initWithNavigationBarClass:[NGGNavigationBar class] toolbarClass:[UIToolbar class]];
    
    NGGNavigationBar *bar = (NGGNavigationBar *)homeNav.navigationBar;
    bar.changeBarHeight = YES;
    [homeNav pushViewController:homeVC animated:NO];
    [self configueVCTabbarItem:homeNav title:nil imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected" tabbarName:@"投注大厅"];
    
    NGGTaskViewController *taskVC = [[NGGTaskViewController alloc] init];
    NGGNavigationController *taskNav = [self configueTabbarItem:taskVC title:@"每日任务" imageName:@"tabbar_task" selectedImageName:@"tabbar_task_selected" tabbarName:@"每日任务"];
    
    
    NGGShopViewController *shopVC = [[NGGShopViewController alloc] initWithNibName:@"NGGShopViewController" bundle:nil];
    NGGNavigationController *shopNav = [self configueTabbarItem:shopVC title:@"金豆抽奖" imageName:@"tabbar_shop" selectedImageName:@"tabbar_shop_selected" tabbarName:@"商城"];
    
    NGGUserViewController *userVC = [[NGGUserViewController alloc] initWithNibName:@"NGGUserViewController" bundle:nil];
    NGGNavigationController *userNav = [self configueTabbarItem:userVC title:@"个人中心" imageName:@"tabbar_user" selectedImageName:@"tabbar_user_selected" tabbarName:@"个人中心"];

    
    [self setViewControllers:@[homeNav, shopNav, userNav]];

    //设置tabbar为黑色
    [[UITabBar appearance] setBarTintColor:UIColorWithRGB(0xf1, 0xf1, 0xf1)];
}

#pragma mark - private methods

- (NGGNavigationController *)configueTabbarItem:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName tabbarName: (NSString *)tabbarName {
    
    // 设置标题
    childVC.title = title;
    
    // 设置图标
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = NGGColor999;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize: 11];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    childVC.tabBarItem.title = tabbarName;
    
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = NGGPrimaryColor;
    selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize: 11];
    [childVC.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = selectedImage;
    
    NGGNavigationController *nav = [[NGGNavigationController alloc] initWithNavigationBarClass:[NGGNavigationBar class] toolbarClass:[UIToolbar class]];
    [nav pushViewController:childVC animated:NO];
    
    return nav;
}


- (void)configueVCTabbarItem:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName tabbarName: (NSString *)tabbarName {
    
    // 设置标题
    childVC.title = title;
    
    // 设置图标
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = NGGColor999;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize: 11];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    childVC.tabBarItem.title = tabbarName;
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = NGGPrimaryColor;
    selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize: 11];
    [childVC.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = selectedImage;
}

@end
