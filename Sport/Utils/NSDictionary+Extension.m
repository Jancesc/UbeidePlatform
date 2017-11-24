//
//  NSDictionary+Extension.m
//  Husky
//
//  Created by zhusheng on 7/15/14.
//  Copyright (c) 2014 37.com. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSString *)stringForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj == nil) {
        return @"";
    }
    return [obj isKindOfClass:[NSString class]] ? obj : [obj description];
}

- (int)intForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    return [obj isKindOfClass:[NSNumber class]]||[obj isKindOfClass:[NSString class]]?((int)[obj integerValue]) : 0;
}

- (long)longForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj longValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (long)[obj longLongValue];
    }
    else
    {
        return 0;
    }
}

- (float)floatForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    return [obj respondsToSelector:@selector(floatValue)] ? [obj floatValue] : 0.0f;
}

- (double)doubleForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    return [obj respondsToSelector:@selector(doubleValue)] ? [obj doubleValue] : 0.0f;
}

- (NSArray *)arrayForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    return [obj isKindOfClass:[NSArray class]] ? obj : [[NSArray alloc] init];
}

- (NSDictionary *) dictionaryForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    return [obj isKindOfClass:[NSDictionary class]] ? obj : [[NSDictionary alloc] init];
}

@end
