//
//  ZSBlockAlertView.h
//  SQGameSDKSim
//
//  Created by macmini000 on 4/16/14.
//  Copyright (c) 2014 37.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBlockAlertView : UIAlertView<UIAlertViewDelegate>

- (void) setClickHandler:(void (^)(NSInteger index)) handler;

@end
