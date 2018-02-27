//
//  NGGWebViewController.m
//  Sport
//
//  Created by Jan on 31/01/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGWebViewController.h"
#import "SCLAlertView.h"

@interface NGGWebViewController ()<WKNavigationDelegate> {
    
}

@end

@implementation NGGWebViewController

#pragma mark - view life circle
- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view = view;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, VIEW_W(self.view), VIEW_H(self.view) - STATUS_BAR_HEIGHT - HOME_INDICATOR)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView.navigationDelegate = self;
    [view addSubview:_webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadRequest];
    self.view.backgroundColor = NGGSeparatorColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)loadRequest {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    [_webView loadRequest:request];
}
@end

