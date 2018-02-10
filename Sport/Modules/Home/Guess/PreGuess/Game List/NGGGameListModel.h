//
//  NGGGameListModel.h
//  Sport
//
//  Created by Jan on 01/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"

@interface NGGGameListModel : NGGModel

@property (nonatomic, copy) NSString *matchID;
@property (nonatomic, copy) NSString *leagueName;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *awayName;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *homeLogo;
@property (nonatomic, copy) NSString *awayLogo;

// 达人赛专有属性 is_play    string    是否已报名 1是 0否
@property (nonatomic, assign) BOOL joined;
@property (nonatomic, copy) NSString *registeryFee;

@end
