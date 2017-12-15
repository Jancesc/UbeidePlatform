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
//"type": "ttg",
//"items":

-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
        
        _title = [dict stringForKey:@"title"];
        _detail = [dict stringForKey:@"explain"];
        _type = [dict stringForKey:@"type"];
        [self setItemCellTypeWithType:_type];
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

- (void)setItemCellTypeWithType:(NSString *)type {
    
//    had    string    胜平负
//    hhad    string    让球胜平负
//    ttg    string    总进球数
//    hf    string    半全场胜平负
//    crs_w    string    比分-主胜
//    crs_l    string    比分-平
//    crs_d    string    比分-客胜
    if ([_type isEqualToString:@"had"] ||
        [_type isEqualToString:@"hhad"]) {
        
        _itemCellType = NGGGuessDetailCellTypeNormal;
    } else if ([_type isEqualToString:@"hf"] ||
               [_type isEqualToString:@"ttg"] ||
               [_type isEqualToString:@"crs_w"] ||
               [_type isEqualToString:@"crs_l"] ||
               [_type isEqualToString:@"crs_d"])
        
        _itemCellType = NGGGuessDetailCellType2Rows;
}
@end
