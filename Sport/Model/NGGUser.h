//
//  NGGUser.h
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGGModel.h"
@interface NGGUser : NGGModel

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *avatarURL;

//性别:1男2女
@property (nonatomic, strong) NSString *sex;

@property (nonatomic, strong) NSString *coin;

@property (nonatomic, strong) NSString *bean;

@property (nonatomic, strong) NSString *invitationCode;

+ (BOOL)gameResultNotificationEnable;

+ (void)changeGameResultNotificationEnable:(BOOL)on;

@end
