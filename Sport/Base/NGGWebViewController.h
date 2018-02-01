//
//  NGGWebViewController.h
//  Sport
//
//  Created by Jan on 31/01/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGCommonViewController.h"
#import <WebKit/WebKit.h>

@interface NGGWebViewController : NGGCommonViewController

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) WKWebView *webView;

@end
