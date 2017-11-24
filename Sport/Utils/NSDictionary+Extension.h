//
//  NSDictionary+Extension.h
//  Husky
//
//  Created by zhusheng on 7/15/14.
//  Copyright (c) 2014 37.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

- (NSString *) stringForKey:(NSString *) key;
- (int) intForKey:(NSString *) key;
- (long) longForKey:(NSString *) key;
- (float) floatForKey:(NSString *) key;
- (double) doubleForKey:(NSString *) key;
- (NSArray *) arrayForKey:(NSString *) key;
- (NSDictionary *) dictionaryForKey:(NSString *) key;

@end
