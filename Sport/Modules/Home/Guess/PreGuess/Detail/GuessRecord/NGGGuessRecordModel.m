//
//  NGGGuessRecordModel.m
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessRecordModel.h"

@implementation NGGGuessRecordModel

-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self =  [super initWithInfo:dict]) {
        
//        bean = 100;
//        ct = 1513653998;
//        item = "ttg@s4";
//        odds = "5.70";
//        "play_name" = "\U8fdb4\U7403";
//        "play_remark" = "";
//        "play_type" = "\U603b\U8fdb\U7403\U6570";
//        "win_bean" = 0;
        _odds = [dict stringForKey:@"odds"];
        _money = [dict stringForKey:@"bean"];
        _profit = [dict stringForKey:@"win_bean"];
        _timeStamp = [dict stringForKey:@"ct"];
        _sectionName = [dict stringForKey:@"play_type"];
        _itemName = [dict stringForKey:@"play_name"];
        _itemID = [dict stringForKey:@"item"];
    }
    return self;
}

@end
