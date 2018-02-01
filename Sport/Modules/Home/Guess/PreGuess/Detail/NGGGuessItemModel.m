//
//  NGGGuessItemModel.m
//  Sport
//
//  Created by Jan on 12/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessItemModel.h"

@implementation NGGGuessItemModel
//"item": "hda@w@1.44",
//"title": "主胜",
//"odds": "1.44"
//"status" : @"0"
-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
    
        if([[dict allKeys] count] == 1 ) {
            
            _title = [dict stringForKey:@"title"];
            return self;
        }
        _itemID = [dict stringForKey:@"item"];
        _title = [dict stringForKey:@"title"];
        _odds = [dict stringForKey:@"odds"];
        if ([[dict allKeys] containsObject:@"status"]) {
            
            _guessable = [dict intForKey:@"status"];//1开启投注 0关闭投注
        }
    }
    return self;
}

@end
