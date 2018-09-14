//
//  ONETheme.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONETheme.h"

#define kConfigKeyText @"content"
#define kConfigKeyFile @"file"
#define kConfigKeyID @"id"
#define kConfigKeyType @"type"

@interface ONETheme()

@property (nonatomic, strong) NSDictionary *textConfig;

@property (nonatomic, strong) NSDictionary *fileConfig;

@end

@implementation ONETheme

- (instancetype)initWithThemeConfig:(NSDictionary *)config
{
    self = [super init];
    if (self) {
        [self _formatConfig:config];
    }
    return self;
}

- (void)_formatConfig:(NSDictionary *)config
{
    _textConfig = [config objectForKey:kConfigKeyText];
    _fileConfig = [config objectForKey:kConfigKeyFile];
    _theme_id = [config objectForKey:kConfigKeyID];
    _theme_name = [config objectForKey:kConfigKeyType];
}

- (UIActivityIndicatorViewStyle)activityViewStyle:(NSString *)act
{
    NSInteger value = [self.textConfig[act] integerValue];
    if (value == 0) {
        return  UIActivityIndicatorViewStyleWhite;
    } else {
        return UIActivityIndicatorViewStyleGray;
    }
}

- (UIColor *)colorWithName:(NSString *)colorName
{
    if ([colorName length] == 0) {
        return [UIColor blackColor];
    }
    id value = self.textConfig[colorName];
    if ([value isKindOfClass:[NSString class]]) {
        
        return [ONETheme colorFromHexString:(NSString *)value];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber* rvalue = value;
        int color32 = [rvalue intValue];
        return [UIColor colorWithHex:color32];
    }
    return [UIColor blackColor];
}

- (UIImage *)imageWithName:(NSString *)imgName
{
    if ([imgName length] == 0) {
        return nil;
    }
    NSString *value = self.fileConfig[imgName];
    return [[UIImage imageNamed:value] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIColor *)colorFromHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 8 or 10 characters
    if ([cString length] < 8) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 8) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *aString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    //    NSLog(@"[colorFromString] %@, %x, %x, %x, %x", stringToConvert, r, g, b, a);
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}


@end
