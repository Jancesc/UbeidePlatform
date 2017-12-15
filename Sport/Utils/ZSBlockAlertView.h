//
//  ZSBlockAlertView.h
//  SQGameSDKSim
//
//  Created by macmini000 on 4/16/14.
//  Copyright (c) 2014 37.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBlockAlertView : NSObject

//ZSBlockAlertView *alert = [[ZSBlockAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelName otherButtonTitles:(NSArray<NSString *> *)otherNames;

- (void) setClickHandler:(void (^)(NSInteger index)) handler;

- (void) show;

@end
