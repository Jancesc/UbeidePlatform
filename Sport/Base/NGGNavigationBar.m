//
//  NGGNavigationBar.m
//  Sport
//
//  Created by Jan on 31/01/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGNavigationBar.h"

@implementation NGGNavigationBar

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (_changeBarHeight) {
        
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
                CGRect subViewFrame = subview.frame;
                subViewFrame.origin.y = -20;
                subViewFrame.size.height = 70;
                [subview setFrame: subViewFrame];
            }
            if ([NSStringFromClass([subview class]) containsString:@"BarContentView"]) {
                CGRect subViewFrame = subview.frame;
                subViewFrame.origin.y = 00;
                subViewFrame.size.height = 70;
                [subview setFrame: subViewFrame];
            }
        }
    }

}

@end
