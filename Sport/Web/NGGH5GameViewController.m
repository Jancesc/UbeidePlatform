//
//  NGGH5GameViewController.m
//  Sport
//
//  Created by Jan on 31/01/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGH5GameViewController.h"
#import "WebViewJavascriptBridge.h"

@interface NGGH5GameViewController ()<WKNavigationDelegate> {
    
}
@property WebViewJavascriptBridge* bridge;

@end

@implementation NGGH5GameViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_bridge) { return; }
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    [self registerWebToNative];
    [self nativeToWeb:@{@"methodName" : @"init", @"key" : @"123", @"name" : @"Jan"}];
    [self loadExamplePage:self.webView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

#pragma mark - web
/*
 *@{
 *    @"token": @"tokenValue",
 *    @"phoneType": @"iPhone7P"
 *}
 */
- (void)nativeToWeb:(NSDictionary *)info {
    
    [self.bridge callHandler:@"nativeToWeb" data:info responseCallback:^(id responseData) {
        NSLog(@"发送给网页的内容为:%@,接收到网页的内容为:%@", info, responseData);
    }];
}

- (void)registerWebToNative {
    
    /***
     * 注册handler,接收Web发送的数据data并回传给Web本地的数据
     * data:Web发送过来的数据
     * responseCallback:是个block，可以带数据执行，例如responseCallback(dataForWeb),dataForWeb为id类型
     * 目测常规的数组字典字符串等都可以传，Web在接受数据后可以进行一些自定义操作
     * 目的：注册完这个方法后，可以实现：Web里调用js的pushViewControllerWithParameters方法后，原生界面根据方法内的具体参数进行界面跳转
     * 具体见WebTest.html文件
     * 另外，可以实现Web里调用js的performMethod方法后，直接调用本网页控制器内写好的方法，这里测试的为其继承类BaseViewController的
     * presentBWithName:sex:方法。
     */
    [self.bridge registerHandler:@"webToNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"网页传过来的数据是%@", data);
        NSString *methodName = data[@"methodName"];
        NSString *token = data[@"token"];
        if ([methodName isEqualToString:@"getUserInfo"]) {
            
            responseCallback(@{@"name" : @"Jan",
                               @"avatar" : @"www.sina.com",
                               @"sex" : @"男",
                               @"phone" : @"15989102657"
                               });
        }
    }];
}

@end
