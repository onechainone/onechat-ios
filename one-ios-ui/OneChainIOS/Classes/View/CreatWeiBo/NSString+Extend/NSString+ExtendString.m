//
//  NSString+ExtendString.m
//
//  Created by HU on 15/3/17.
//  Copyright (c) 2015年 JDYG. All rights reserved.
//

#import "NSString+ExtendString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ExtendString)



- (NSString *)checkBlankString
{
    if (NULL == self || [self isEqual:nil] || [self isEqual:Nil])
        return  [NSString stringWithFormat:@"%@",@""];
    if ([self isEqual:[NSNull null]])
        return  [NSString stringWithFormat:@"%@",@""];
    if (![self isKindOfClass:[NSString class]]) {
        return  [NSString stringWithFormat:@"%@",@""];
    }
    if (0 == [self length] || 0 == [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return  [NSString stringWithFormat:@"%@",@""];
    if([self isEqualToString:@"(null)"])
        return  [NSString stringWithFormat:@"%@",@""];
    if([self isEqualToString:@"<null>"])
        return  [NSString stringWithFormat:@"%@",@""];
    
    return self;
}

- (BOOL)isBlankString
{
    if (self == NULL || [self isEqual:nil] || [self isEqual:Nil] || self == nil)
        return  YES;
    if ([self isEqual:[NSNull null]])
        return  YES;
    if (![self isKindOfClass:[NSString class]] )
        return  YES;
    if (0 == [self length] || 0 == [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return  YES;
    if([self isEqualToString:@"(null)"])
        return  YES;
    if([self isEqualToString:@"<null>"])
        return  YES;
    if([self isEqualToString:@""])
        return  YES;
    
    return NO;
}

-(BOOL)isJsonStringWithObj:(NSObject *)obj
{
    NSString *jsonStr =[[NSString stringWithFormat:@"%@",obj] checkBlankString];
    NSObject *o =[jsonStr JSONValue];
    if ([o isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else{
        return NO;
        
    }
}

- (NSString*)md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (unsigned int)self.length, digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

- (NSString *)base64DecodeString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
