//
//  NSString+ExtendString.h
//
//  Created by HU on 15/3/17.
//  Copyright (c) 2015年 JDYG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface NSString (ExtendString)

- (NSString *)checkBlankString;
- (BOOL)isBlankString;
- (BOOL)isJsonStringWithObj:(NSObject *)obj;
- (NSString*)md5;
- (NSString *)base64DecodeString;
@end
