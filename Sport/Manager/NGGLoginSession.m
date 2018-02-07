//
//  NGGUserLoginSession.m
//
//  Created by zhusheng on 7/30/15.
//  Copyright (c) 2015 zhusheng. All rights reserved.
//

#import "NGGLoginSession.h"

NSString *const NGGUserDidLoginNotificationName = @"NGGUserDidLoginNotificationName";
NSString *const NGGUserDidLogoutNotificationName = @"NGGUserDidLogoutNotificationName";
NSString *const NGGUserDidModifyUserInfoNotificationName = @"NGGUserDidModifyUserInfoNotificationName";

//static NSString *const kNGGSavedLoginInfoUserDefaultsKey = @"NGGSavedLoginInfoUserDefaultsKey";

static NGGLoginSession *_activeSession = nil;

@interface NGGLoginSession ()

@property (nonatomic, strong) NGGUser *currentUser;

@end

@implementation NGGLoginSession

+ (NGGLoginSession *)activeSession
{
    if (_activeSession) {
        return _activeSession;
    }
    
    NGGUser *user = [NGGUser loadFromDisk];
    if (user) {
      
        _activeSession = [NGGLoginSession new];
        _activeSession.currentUser = user;
    }
    
    return _activeSession;
}

+ (void)destroyActiveSession
{
    if (_activeSession) {
        
        [_activeSession.currentUser removeFromDisk];
        _activeSession = nil;
    }
}

+ (NGGLoginSession *)newSessionWithLoginInformation:(NSDictionary *)info {
    
    NGGLoginSession *session = [NGGLoginSession new];
    session.currentUser = [[NGGUser alloc] initWithInfo:info];
    _activeSession = session;
    [session.currentUser saveToDisk];
    return session;
}


-(void)saveUserInfo {
    
    if (_currentUser) {
        
        [_currentUser saveToDisk];
    }
}

- (NGGUser *)currentUser {
    
    return _currentUser;
}

@end
