//
//  NGGLeagueModel.m
//  Sport
//
//  Created by Jan on 01/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGLeagueModel.h"

@implementation NGGLeagueModel

- (instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self = [super initWithInfo:dict]) {
        
        if (!isStringEmpty([dict stringForKey:@"c_id"])) {
            
            _leagueID = [dict stringForKey:@"c_id"];
        } if (!isStringEmpty([dict stringForKey:@"c_type"])) {
            
            _leagueID = [dict stringForKey:@"c_type"];
        }
        _leagueName = [dict stringForKey:@"c_name"];
        _count = [dict stringForKey:@"total"];
        _leagueLogo = [dict stringForKey:@"c_logo"];
    }
    return self;
}

@end
