//
//  NGGGameDateModel.m
//  Sport
//
//  Created by Jan on 01/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameDateModel.h"

@implementation NGGGameDateModel


- (instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self = [super initWithInfo:dict]) {
        
        _timeStamp = [dict stringForKey:@"t"];
        _dateName = [dict stringForKey:@"w"];
        _count = [dict stringForKey:@"total"];
    }
    return self;
}
@end
