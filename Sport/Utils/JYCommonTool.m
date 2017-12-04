//
//  JYCommonTool.m
//  Sport
//
//  Created by Jan on 01/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "JYCommonTool.h"

@implementation JYCommonTool

+ (NSString *)dateFormatWithInterval:(NSInteger)intetval format:(NSString *)format {
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:intetval];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    
   return  [fmt stringFromDate:date];
}

@end
