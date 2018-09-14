//
//  NSString+Decimal.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/16.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Decimal)

// 加
- (NSString *)stringByAdding:(NSString *)param;
// 减
- (NSString *)stringBySubtracting:(NSString *)param;
// 乘
- (NSString *)stringByMultiplying:(NSString *)param;
// 除
- (NSString *)stringByDividing:(NSString *)param;
// 判断是否相等
- (BOOL)isEqualToDecimalString:(NSString *)decimalString;
// 判断是否大于
- (BOOL)isGreaterThanDecimalString:(NSString *)decimalString;
// 判断是否小于
- (BOOL)isSmallerThanDecimalString:(NSString *)decimalString;

/**
 保留小数点后位数

 @param scale 位数
 @param isRound 是否四舍五入
 @return value
 */
- (NSString *)formatDecimalString:(NSUInteger)scale round:(BOOL)isRound;

/**
 补足小数点后位数

 @param scale 位数
 @return value
 */
- (NSString *)formatPointString:(NSUInteger)scale;
@end
