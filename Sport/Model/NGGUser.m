//
//  NGGUser.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGUser.h"

#define NGGGameResultNotificationEnableKey @"notificationkey"

@interface NGGUser () <NSCoding> {
    
    
}

@end

@implementation NGGUser

//归档(序列化)
-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.coin forKey:@"coin"];
    [aCoder encodeObject:self.bean forKey:@"bean"];
    [aCoder encodeObject:self.invitationCode forKey:@"invitationCode"];
    [aCoder encodeObject:self.point forKey:@"point"];

}

//反归档(反序列化)

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.coin = [aDecoder decodeObjectForKey:@"coin"];
        self.bean = [aDecoder decodeObjectForKey:@"bean"];
        self.invitationCode = [aDecoder decodeObjectForKey:@"invitationCode"];
        self.point = [aDecoder decodeObjectForKey:@"point"];
    }
    
    return self;
}

+ (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"info.archive"];
}

- (void)saveToDisk {
    
    //获取归档文件路径
    NSString *filePath = [NGGUser dataFilePath];
    if ([NSKeyedArchiver archiveRootObject:self toFile:filePath]) {
        NSLog(@"\n\n\n归档成功：路径%@",filePath);
    }
}

+ (NGGUser *)loadFromDisk {
    
    //解归档
    NGGUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[NGGUser dataFilePath]];
    NSLog(@"\n解归档成功: %@ %@",user,user.nickname);
    return user;
}

- (void)removeFromDisk {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager removeItemAtPath:[NGGUser dataFilePath] error:nil];
    NSLog(@"删除用户数据成功:%d",success);
}

#pragma mark -
- (instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self = [super initWithInfo:dict]) {
        // "uid": 50003,
        //            "token": "yc71qt-5chipvnq3-dyf",
        //            "phone": "18565556200",
        //            "nickname": "游客7499",
        //            "avatar_img": "http://wx7.bigh5.com/fb/web/uploads/default/avatar.png",
        //            "sex": "1",
        //            "coin": "0",
        //            "bean": "1000",
        //            "Invite_code": "6si2"
        
        _uid = [dict stringForKey:@"uid"];
        _token = [dict stringForKey:@"token"];
        _phone = [dict stringForKey:@"phone"];
        _nickname = [dict stringForKey:@"nickname"];
        _avatarURL = [dict stringForKey:@"avatar_img"];
        _sex = [dict stringForKey:@"sex"];
        _coin = [dict stringForKey:@"coin"];
        _bean = [dict stringForKey:@"bean"];
        _invitationCode = [dict stringForKey:@"Invite_code"];
        _point = [dict stringForKey:@"score"];
    }
    return self;
}

+(BOOL)gameResultNotificationEnable {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:NGGGameResultNotificationEnableKey];
}

+ (void)changeGameResultNotificationEnable:(BOOL)on {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:NGGGameResultNotificationEnableKey];
    [defaults synchronize];
}


@end
