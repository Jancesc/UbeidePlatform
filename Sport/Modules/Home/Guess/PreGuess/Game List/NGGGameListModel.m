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
        
        _matchID = [dict stringForKey:@"match_id"];
        _leagueName = [dict stringForKey:@"c_name"];
        _homeName = [dict stringForKey:@"h_name"];
        _awayName = [dict stringForKey:@"a_name"];
        _timeString = [dict stringForKey:@"match_time"];
    }
    return self;
}
@end
