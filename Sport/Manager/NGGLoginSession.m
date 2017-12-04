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

static NSString *const kNGGSavedLoginInfoUserDefaultsKey = @"NGGSavedLoginInfoUserDefaultsKey";

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
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *savedLoginInfo = [standardUserDefaults dictionaryForKey:kNGGSavedLoginInfoUserDefaultsKey];
    if (savedLoginInfo) {
       
        _activeSession = [NGGLoginSession newSessionWithLoginInformation:savedLoginInfo];
    }
    
    return _activeSession;
}

+ (void)destroyActiveSession
{
    if (_activeSession) {
        _activeSession = nil;
    }
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:kNGGSavedLoginInfoUserDefaultsKey];
    [standardUserDefaults synchronize];
}

+ (NGGLoginSession *)newSessionWithLoginInformation:(NSDictionary *)info
{
    NGGLoginSession *session = [NGGLoginSession new];
   
    session.currentUser = [[NGGUser alloc] initWithInfo:info];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:info forKey:kNGGSavedLoginInfoUserDefaultsKey];
    [standardUserDefaults synchronize];
    return session;
}

- (void)updateUserInfo:(NSDictionary *)userInfo
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *infoM = [NSMutableDictionary dictionaryWithDictionary:[standardUserDefaults dictionaryForKey:kNGGSavedLoginInfoUserDefaultsKey]];
    NSArray *keyArray = [userInfo allKeys];
    for (NSString *key in keyArray) {
        
        [infoM setObject:userInfo[key] forKey:key];
    }
    
    NSDictionary *finalInfo = [infoM copy];
    _currentUser = [[NGGUser alloc] initWithInfo:finalInfo];
    [standardUserDefaults setObject:finalInfo forKey:kNGGSavedLoginInfoUserDefaultsKey];
    [standardUserDefaults synchronize];
}

- (NGGUser *)currentUser {
    
    return _currentUser;
}

@end
