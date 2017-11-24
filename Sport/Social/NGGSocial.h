//
//  NGGSocial.h
//  sport
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGGSocial : NSObject

+ (instancetype) sharedInstance;

- (BOOL) isWechatInstalled;
- (BOOL) isWeiboInstalled;
- (BOOL) isQQinstalled;

- (void) handleOpenURL:(NSURL *) url;

//authorize
- (void) sendWechatAuthorizeRequestWithViewController:(UIViewController *) viewController completion:(void (^)(NSString *wxCode)) completion;
- (void) sendWeiboAuthorizeRequestCompletion:(void (^)(NSDictionary *info)) completion;
- (void) sendQQAuthorizeRequestCompletion:(void (^)(NSDictionary *info)) completion;

//share
- (void) sendWechatSessionRequestWithMessage:(NSDictionary *) message;
- (void) sendWechatTimelineRequestWithMessage:(NSDictionary *) message;
- (void) sendWechatFavoriteRequestWithMessage:(NSDictionary *) message;
- (void) sendWeiboRequestWithMessage:(NSDictionary *) message;
- (void) sendQQShareRequestWithMessage:(NSDictionary *) message;
- (void) sendQZoneShareRequestWithMessage:(NSDictionary *) message;

//pay
- (void) sendWechatPayRequestWithMessage:(NSDictionary *) message completion:(void (^)(NSString *returnKey, NSString *errorMsg)) completion;
- (void) sendAlipayRequestWithOrder:(NSString *) orderStr completion:(void (^)(NSDictionary *resultDic, NSString *errorMsg)) completion;

@end
