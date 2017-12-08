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

+ (CGFloat)calculateStringWidth:(NSString *) string maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.width;
}
@end
