//
//  NGGLoginSession.h
//
//  Created by zhusheng on 7/30/15.
//  Copyright (c) 2015 zhusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGGUser.h"

extern NSString *const NGGUserDidLoginNotificationName;
extern NSString *const NGGUserDidLogoutNotificationName;
extern NSString *const NGGUserDidModifyUserInfoNotificationName;

@interface NGGLoginSession : NSObject

+ (NGGLoginSession *) activeSession;
+ (void) destroyActiveSession;

+ (NGGLoginSession *) newSessionWithLoginInformation:(NSDictionary *) info;

- (NGGUser *)currentUser;

- (void)saveUserInfo;
@end
