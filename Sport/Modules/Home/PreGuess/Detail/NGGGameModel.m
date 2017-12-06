//
//  NGGGameModel.m
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameModel.h"

@implementation NGGGameModel

-(instancetype)initWithInfo:(NSDictionary *)dict {
    
    if (self == [super initWithInfo:dict]) {
        
        _matchID = @"2017622";
        _hda = @{
            @"W": @"1.44",
            @"D": @"4.1",
            @"L": @"5.3",
            };
        
        _hhda = @{
                  @"H": @"-1",
                  @"W": @"2.32",
                  @"D": @"3.6",
                  @"L": @"2.39",
                  };
        
        _ttg = @{
            @"s0": @"16.00",
            @"s1": @"6.00",
            @"s2": @"3.80",
            @"s3": @"3.40",
            @"s4": @"4.40",
            @"s5": @"7.00",
            @"s6": @"11.00",
            @"s7": @"15.00",
            };
        
        _hf = @{
            @"ww": @"1.90",
            @"wd": @"17.00",
            @"wl": @"40.00",
            @"dw": @"4.40",
            @"dd": @"6.50",
            @"dl": @"11.00",
            @"lw": @"20.00",
            @"ld": @"17.00",
            @"ll": @"8.20",
        };
        
    }
    
    return self;
}
@end
