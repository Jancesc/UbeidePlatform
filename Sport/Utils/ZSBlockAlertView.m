//
//  ZSBlockAlertView.m
//  SQGameSDKSim
//
//  Created by macmini000 on 4/16/14.
//  Copyright (c) 2014 37.com. All rights reserved.
//

#import "ZSBlockAlertView.h"
#import <objc/runtime.h>

static void *kZSBlockAlertViewClickHandlerKey = @"kZSBlockAlertViewClickHandlerKey";

@implementation ZSBlockAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setClickHandler:(void (^)(NSInteger))handler
{
    [self setDelegate:self];
    objc_setAssociatedObject(self, kZSBlockAlertViewClickHandlerKey, handler, OBJC_ASSOCIATION_COPY);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^handler)(NSInteger) = objc_getAssociatedObject(self, kZSBlockAlertViewClickHandlerKey);
    if (handler) {
        handler(buttonIndex);
    }
}

@end
