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

-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
    
        _itemID = [dict stringForKey:@"item"];
        _title = [dict stringForKey:@"title"];
        _odds = [dict stringForKey:@"odds"];

    }
    return self;
}

@end
