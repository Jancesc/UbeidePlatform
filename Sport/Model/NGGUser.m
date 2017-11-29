//
//  NGGUser.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGUser.h"

@implementation NGGUser

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
        _nickName = [dict stringForKey:@"nickname"];
        _avatarURL = [dict stringForKey:@"avatar_img"];
        _sex = [dict stringForKey:@"sex"];
        _coin = [dict stringForKey:@"coin"];
        _bean = [dict stringForKey:@"bean"];
        _invitationCode = [dict stringForKey:@"Invite_code"];

    }
    return self;
}
@end
