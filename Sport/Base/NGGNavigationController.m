//
//  NGGNavigationController.m
//  shelves
//
//  Created by Jan on 07/08/2017.
//  Copyright © 2017 niugaga. All rights reserved.
//

#import "NGGNavigationController.h"
#import "NGGNavigationBar.h"
@interface NGGNavigationController ()

@end

@implementation NGGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage *backButtonBackgroundImage = [[UIImage imageNamed:@"back"] imageWithColor:[UIColor whiteColor]];
//    backButtonBackgroundImage = [backButtonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonBackgroundImage.size.width+1, 0, 0) resizingMode:UIImageResizingModeStretch];
//    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    

    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18.f]};
    
    //设置navBar字体颜色
    //在plist里面, 加上View controller-based status bar appearance, 并且设置为NO
    self.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    //设置NavBar的背景颜色
    [NGGNavigationBar appearance].barTintColor = NGGPrimaryColor;
    [UINavigationBar appearance].barTintColor = NGGPrimaryColor;

    //隐藏navgationBar底部的黑线
    UIImageView *hairImageView = [self findHairlineImageViewUnder:self.view];
    if (hairImageView){
        
        hairImageView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 找出navgationBar的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && CGRectGetHeight(view.bounds) <= 1.f) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
