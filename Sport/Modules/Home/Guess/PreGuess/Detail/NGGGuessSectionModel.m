//
//  NGGGuessSectionModel.m
//  Sport
//
//  Created by Jan on 12/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessSectionModel.h"

@implementation NGGGuessSectionModel

//"title": "胜平负",
//"explain": "全场90分钟（含伤停补时）的比赛结果",
//"items":

-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
        
        _title = [dict stringForKey:@"title"];
        _detail = [dict stringForKey:@"explain"];
        
        NSArray *itemArray = [dict arrayForKey:@"items"];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger index = 0; index < [itemArray count]; index++) {
            
            NSDictionary *itemInfo = itemArray[index];
            NGGGuessItemModel *model = [[NGGGuessItemModel alloc] initWithInfo:itemInfo];
            [arrayM addObject:model];
        }

        _arrayOfItem = [arrayM copy];
    }
    return self;
}
@end
