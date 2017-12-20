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

+ (NSString *)stringDisposeWithFloat:(float)floatValue {
    
    NSString *str = [NSString stringWithFormat:@"%.2f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++) {
        
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."]){//避免像2.0000这样的被解析成2.
        
        //s.substring(0, len - i - 1);
        return [str substringToIndex:[str length]-1];
    } else {
        
        return str;
    }
}
@end
