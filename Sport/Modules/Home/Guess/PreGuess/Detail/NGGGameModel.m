//
//  NGGGameModel.m
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameModel.h"

@implementation NGGGameModel

//"bean": "1000",
//"match_id": "102285",
//"match_time": "1513540800",
//"h_name": "里昂",
//"a_name": "马赛",
//"score": "1:2",
//"status": "0",
//"list": [
-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
        
        _matchID = [dict stringForKey:@"match_id"];
        _startTime = [dict stringForKey:@"match_time"];
        _homeName = [dict stringForKey:@"h_name"];
        _awayName = [dict stringForKey:@"a_name"];
        _score = [dict stringForKey:@"score"];
        _status = [dict stringForKey:@"status"];
        
        
        [[NGGLoginSession activeSession] updateUserInfo:@{@"bean" : dict[@"bean"]}];
        [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidModifyUserInfoNotificationName object:nil];
        
        NSArray *sectionArray = [dict arrayForKey:@"list"];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger index = 0; index < [sectionArray count]; index++) {
            
            NSDictionary *sectionInfo = sectionArray[index];
            NGGGuessSectionModel *model = [[NGGGuessSectionModel alloc] initWithInfo:sectionInfo];
            [arrayM addObject:model];
        }
        
        _arrayOfSection = [arrayM copy];
    }
    return self;
}
@end
