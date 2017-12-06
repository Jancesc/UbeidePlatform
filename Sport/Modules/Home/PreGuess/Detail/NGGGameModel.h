//
//  NGGGameModel.h
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"

@interface NGGGameModel : NGGModel

@property (nonatomic, strong) NSString *matchID;

///胜平负数据
//"hda": {
//    "W": "1.44",
//    "D": "4.1",
//    "L": "5.3",
//}
@property (nonatomic, strong) NSDictionary *hda;
///让球胜平负
//"hhda": {
//    "H": "-1",
//    "W": "2.32",
//    "D": "3.6",
//    "L": "2.39",
//}
@property (nonatomic, strong) NSDictionary *hhda;
//总进球数数组
//"ttg": {
//    "s0": "16.00",
//    "s1": "6.00",
//    "s2": "3.80",
//    "s3": "3.40",
//    "s4": "4.40",
//    "s5": "7.00",
//    "s6": "11.00",
//    "s7": "15.00",
//    "ut": "1511418797",
//    "single": "1"
//},
@property (nonatomic, strong) NSDictionary *ttg;

//半全场胜平负数组
//"hf": {
//    "ww": "1.90",
//    "wd": "17.00",
//    "wl": "40.00",
//    "dw": "4.40",
//    "dd": "6.50",
//    "dl": "11.00",
//    "lw": "20.00",
//    "ld": "17.00",
//    "ll": "8.20",
//    "ut": "1511418797",
//    "single": "1"
//}
@property (nonatomic, strong) NSDictionary *hf;

//全场比分数组
//"crs": {
//    "L": {
//        "0:0": "16.00",
//        "1:1": "7.50",
//        "2:2": "13.00",
//        "3:3": "39.00"
//    }
@property (nonatomic, strong) NSDictionary *crs;

//平分数组
//"L": {
//    "0:0": "16.00",
//    "1:1": "7.50",
//    "2:2": "13.00",
//    "3:3": "39.00"
//}
@property (nonatomic, strong) NSDictionary *L;

//胜比分数组
//"W": {
//    "1:0": "8.00",
//    "2:0": "7.50",
//    "2:1": "6.50",
//    "3:0": "10.50",
//    "3:1": "10.00",
//    "3:2": "17.00",
//    "4:0": "19.00",
//    "4:1": "19.00",
//    "4:2": "34.00",
//    "5:0": "39.00",
//    "5:1": "39.00",
//    "5:2": "70.00"
//},
@property (nonatomic, strong) NSDictionary *W;

//负比分数组
//"D": {
//    "0:1": "16.00",
//    "0:2": "29.00",
//    "0:3": "70.00",
//    "0:4": "250.0",
//    "0:5": "600.0",
//    "1:2": "13.00",
//    "1:3": "39.00",
//    "1:4": "120.0",
//    "1:5": "400.0",
//    "2:3": "34.00",
//    "2:4": "100.0",
//    "2:5": "400.0"
//}

@property (nonatomic, strong) NSDictionary *D;

@end
