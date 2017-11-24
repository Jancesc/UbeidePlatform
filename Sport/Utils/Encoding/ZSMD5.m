//
//  ZSMD5.m
//  sqwad
//
//  Created by 朱 圣 on 11/2/13.
//  Copyright (c) 2013 37wan. All rights reserved.
//

#import "ZSMD5.h"
#import <CommonCrypto/CommonCrypto.h>

NSData *MD5HexDigestD(NSString *str)
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str,(CC_LONG) strlen(original_str), result);
    
    return [[NSData alloc] initWithBytes:result length:sizeof(result)];
}

NSString *MD5HexDigest(NSString *str)
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str,(CC_LONG) strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

NSString *MD5hexDigest16(NSString *str)
{
    NSString *hash32 = MD5HexDigest(str);
    return [hash32 substringWithRange:NSMakeRange(8, 16)];
}
