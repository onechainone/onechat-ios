//
//  NSString+Extension.h
//  Easemob
//
//  Created by nacker on 15/12/22.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)utf8String:(NSString *)str;

+ (NSString *)transformedValue:(long long)value;

- (BOOL)isChinese;

- (BOOL)isURL;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

+ (NSString *)timeWithDate:(NSDate *)date;


- (NSString *)pinyin;
- (NSString *)pinyinInitial;


/**
 *  正则判断手机号码
 */
- (BOOL)isMobileNum;

+ (NSString *)rightURLString:(NSString *)url;

- (BOOL)containsLink;

- (BOOL)isAccountId;

- (NSString *)sha1;

+(NSMutableAttributedString*)getMutableAttributedStringFromString:(NSString*)string
                                                         withFont:(UIFont*)font
                                                    withTextColor:(UIColor *)textColor
                                                    withLineSpace:(CGFloat)lineSpace;
+ (CGFloat)heightFromAttributedString:(NSAttributedString *)attr
                                width:(CGFloat)width;

- (NSString *)formalCommunityImageUrl;
- (NSString *)formalCommunityVideoUrl;
@end
