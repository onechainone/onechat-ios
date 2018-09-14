//
//  NSString+Extension.m
//  Easemob
//
//  Created by nacker on 15/12/22.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Extension)

+ (NSString *)utf8String:(NSString *)str
{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)transformedValue:(long long)value {
    double convertedValue = value;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes", @"KB", @"MB", @"GB", @"TB", nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

- (BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isURL{
    NSString * url = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:url];
    if (URL && URL.scheme && URL.host) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    if (iOS7) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

//- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
//{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    if (iOS7) {
//        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    } else {
//        return [self sizeWithFont:font constrainedToSize:maxSize];
//    }
//}

+ (NSString *)timeWithDate:(NSDate *)date
{
    if (date == nil)
    {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *now = [NSDate date];
    
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:unit fromDate:now];
    NSInteger nowHour = components.hour;
    NSInteger nowMinute = components.minute;
    NSInteger nowSecond = components.second;
    NSInteger nowWeekday = components.weekday;
    
    components = [calendar components:unit fromDate:date];
    NSInteger dateHour = components.hour;
    NSInteger dateMinute = components.minute;
    NSInteger dateWeekday = components.weekday;
    
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    
    NSString *result = @"";
    if (interval > 24*60*60*7)
    {
        //一个星期之前显示全部时间
        result = [formatter stringFromDate:date];
    }
    else if(interval >= 24*60*60*1+nowHour*60*60+nowMinute*60+nowSecond)//大于等于2天
    {
        //上个星期
        if(nowWeekday<dateWeekday)
        {
            result = [formatter stringFromDate:date];
        }
        else    //本星期要显示星期
        {
            result = [NSString stringWithFormat:@"%@ %02zi:%02zi", [self stringedWeekday:dateWeekday], dateHour, dateMinute];
        }
    }
    else if(interval >= nowHour*60*60+nowMinute*60+nowSecond)    //昨天
    {
        result = [NSString stringWithFormat:@"%@ %02zi:%02zi", @"昨天", dateHour, dateMinute];
    }
    else
    {
        result = [NSString stringWithFormat:@"%02zi:%02zi", dateHour, dateMinute];
    }
    
    return result;
}

+ (NSString *)stringedWeekday:(NSUInteger)weekday
{
    assert(weekday>=1 && weekday<=7);
    
    return @[@"星期日",
             @"星期一",
             @"星期二",
             @"星期三",
             @"星期四",
             @"星期五",
             @"星期六"][weekday-1];
}


- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    return initial;
}

- (BOOL)isMobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186,183
     * 电信：133,1349,153,180,189,177
     * 其他    170
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[07])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[356])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349|7[07])\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    if (res1 || res2 || res3 || res4 ){
        return YES;
    }else{
        return NO;
    }
}
+ (NSString *)rightURLString:(NSString *)url
{
    NSArray *array = [url componentsSeparatedByString:@"//"];
    if (array.count > 2) {
        
        NSMutableString *mString = [NSMutableString stringWithString:array[1]];
        NSInteger i = 2;
        while (i < array.count) {
            [mString appendString:@"/"];
            [mString appendString:array[i]];
            i++;
        }
        NSString *finalString = [[array[0] stringByAppendingString:@"//"] stringByAppendingString:[mString copy]];
        return finalString;
    } else {
        
        return url;
    }
}

- (BOOL)containsLink
{
    NSString *regular = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSString *linkString = self;
    if (linkString.length == 0) {
        return nil;
    }
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *match = [exp matchesInString:linkString options:NSMatchingReportProgress range:NSMakeRange(0, linkString.length)];
    
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in match) {
        NSString *str = [self substringWithRange:result.range];
        NSURL *url = [NSURL URLWithString:str];
        if ([str rangeOfString:@"http"].location == NSNotFound &&
            [str rangeOfString:@"https"].location == NSNotFound) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str]];
        }
        [results addObject:[NSTextCheckingResult linkCheckingResultWithRange:result.range URL:url]];
    }
    if (results.count > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isAccountId
{
    NSArray *array = [self componentsSeparatedByString:@"."];
    if (array != nil && array.count == 3) {
        return YES;
    }
    return NO;
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
}

+(NSMutableAttributedString*)getMutableAttributedStringFromString:(NSString*)string
                                                         withFont:(UIFont*)font
                                                    withTextColor:(UIColor *)textColor
                                                    withLineSpace:(CGFloat)lineSpace
{
    if (!string) {
        return nil;
    }
    NSMutableParagraphStyle *pagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [pagraphStyle setLineSpacing:lineSpace];
    [pagraphStyle setAlignment:NSTextAlignmentJustified];
    //    [pagraphStyle setParagraphSpacing:AD_HEIGHT(5.0)];
    
    NSDictionary *attributedDict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,textColor,NSForegroundColorAttributeName,pagraphStyle,NSParagraphStyleAttributeName, nil];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributedDict];
    
    return attributedString;
}

+ (CGFloat)heightFromAttributedString:(NSAttributedString *)attr width:(CGFloat)width
{
    CGRect contentFrame = [attr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat height = contentFrame.size.height;
    return height;

}

- (NSString *)formalCommunityImageUrl
{
    if (self == nil) {
        return @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",[ONEUrlHelper communityImagePrefix],self];
    if ([url length] == 0) {
        return @"";
    }
    if ([@"//" rangeOfString:url].location != NSNotFound) {
        url = [url stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    }
    return url;
}

- (NSString *)formalCommunityVideoUrl
{
    if (self == nil) {
        return @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",[ONEUrlHelper communityVideoPrefix],self];
    if ([url length] == 0) {
        return @"";
    }
    url = [url stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    return url;
}
@end
