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
        
//        "odds": "1.91",
//        "bean": "100",
//        "win_bean": "0",
//        "ct": "1512038547",
//        "play_remark": "",
//        "play_type": "胜平负",
//        "play_name": "主胜"
        _odds = [dict stringForKey:@"odds"];
        _money = [dict stringForKey:@"bean"];
        _profit = [dict stringForKey:@"win_bean"];
        _timeStamp = [dict stringForKey:@"ct"];
        _sectionName = [dict stringForKey:@"play_type"];
        _itemName = [dict stringForKey:@"play_name"];
    }
    return self;
}

@end
