//
//  NGGGameModel.m
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameModel.h"

@implementation NGGGameModel

//"match_id": "2047622",
//"start_time": "1512123606",
//"h_name": "墨尔雄心",
//"a_name": "珀斯光荣",
//"list": [
-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
        
        _matchID = [dict stringForKey:@"match_id"];
        _startTime = [dict stringForKey:@"start_time"];
        _homeName = [dict stringForKey:@"h_name"];
        _awayName = [dict stringForKey:@"a_name"];
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
