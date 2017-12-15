//
//  ZSBlockAlertView.m
//  SQGameSDKSim
//
//  Created by macmini000 on 4/16/14.
//  Copyright (c) 2014 37.com. All rights reserved.
//

#import "ZSBlockAlertView.h"
#import <objc/runtime.h>
#import "SCLAlertView.h"

static void *kZSBlockAlertViewClickHandlerKey = @"kZSBlockAlertViewClickHandlerKey";

@interface ZSBlockAlertView () {
    
    SCLAlertView *_alertView;
    
    NSString *_title;
    NSString *_message;
}

@end

@implementation ZSBlockAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelName otherButtonTitles:(NSArray<NSString *> *)otherNames {
    
    if (self = [super init]) {
        
        _title = title;
        _message = message;
        
        _alertView = [[SCLAlertView alloc] initWithNewWindow];
        _alertView.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [_alertView setHorizontalButtons:YES];
        
        NSInteger tagIndex = 0;
        
        if (!isStringEmpty(cancelName)) {
          
            SCLButton *closeButton = [_alertView addButton:cancelName target:self selector:@selector(buttonClicked:)];
            closeButton.tag = tagIndex++;
            closeButton.buttonFormatBlock = ^NSDictionary* (void) {
                
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                buttonConfig[@"backgroundColor"] = UIColorWithRGB(0x72, 0x73, 0x75);
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                buttonConfig[@"font"] = [UIFont boldSystemFontOfSize:14.f];
                return buttonConfig;
            };
        }
        
        for (NSInteger index = 0; index < [otherNames count]; index++) {
            
            SCLButton *otherButton = [_alertView addButton:otherNames[index] target:self selector:@selector(buttonClicked:)];
            otherButton.tag = tagIndex++;
            otherButton.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                buttonConfig[@"backgroundColor"] = NGGViceColor;
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                buttonConfig[@"font"] = [UIFont boldSystemFontOfSize:14.f];
                return buttonConfig;
            };
        }
    }
    
    return self;
}

- (void)show {
    
    [_alertView showNotice:_title subTitle:_message closeButtonTitle:nil duration:0.0];
}


- (void)setClickHandler:(void (^)(NSInteger))handler {
    
    objc_setAssociatedObject(self, kZSBlockAlertViewClickHandlerKey, handler, OBJC_ASSOCIATION_COPY);
}

- (void)buttonClicked:(UIControl *)button
{
    void (^handler)(NSInteger) = objc_getAssociatedObject(self, kZSBlockAlertViewClickHandlerKey);
    if (handler) {
        handler(button.tag);
    }
}

@end
