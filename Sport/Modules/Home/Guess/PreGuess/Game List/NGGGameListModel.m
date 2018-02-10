//
//  NGGGameListModel.m
//  Sport
//
//  Created by Jan on 01/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameListModel.h"

@implementation NGGGameListModel

- (instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self = [super initWithInfo:dict]) {
        
//        "match_id": "2704855",
//        "c_name": "意杯",
//        "h_name": "尤文图斯",
//        "a_name": "热那亚",
//        "match_time": "1513770300",
//        "match_date": "2017-12-20"
        _matchID = [dict stringForKey:@"match_id"];
        _leagueName = [dict stringForKey:@"c_name"];
        _homeName = [dict stringForKey:@"h_name"];
        _awayName = [dict stringForKey:@"a_name"];
        _timeString = [dict stringForKey:@"match_time"];
        _homeLogo = [dict stringForKey:@"h_logo"];
        _awayLogo = [dict stringForKey:@"a_logo"];
        
        //达人赛专用属性
        _joined = [dict intForKey:@"is_play"];
        _registeryFee = [dict stringForKey:@"need_bean"];

    }
    return self;
}
@end
