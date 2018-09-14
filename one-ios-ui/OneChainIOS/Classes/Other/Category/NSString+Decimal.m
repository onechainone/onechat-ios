//
//  NSString+Decimal.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/16.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "NSString+Decimal.h"

#define InvalidCalculate(param) if ([self length] == 0 || [param length] == 0)
#define Self_Decimal [NSDecimalNumber decimalNumberWithString:self]
#define Param_Decimal(param) [NSDecimalNumber decimalNumberWithString:param]

@implementation NSString (Decimal)


- (NSString *)stringByAdding:(NSString *)param
{
    InvalidCalculate(param) return @"";
    return [[Self_Decimal decimalNumberByAdding:Param_Decimal(param)] stringValue];
}

- (NSString *)stringBySubtracting:(NSString *)param
{
    InvalidCalculate(param) return @"";
    return [[Self_Decimal decimalNumberBySubtracting:Param_Decimal(param)] stringValue];
}

- (NSString *)stringByMultiplying:(NSString *)param
{
    InvalidCalculate(param) return @"";
    return [[Self_Decimal decimalNumberByMultiplyingBy:Param_Decimal(param)] stringValue];
}

- (NSString *)stringByDividing:(NSString *)param
{
    InvalidCalculate(param) return @"";
    if ([Param_Decimal(param) compare:@0] == NSOrderedSame) {
        return @"0";
    }
    return [[Self_Decimal decimalNumberByDividingBy:Param_Decimal(param)] stringValue];
}

- (BOOL)isEqualToDecimalString:(NSString *)decimalString
{
    InvalidCalculate(decimalString) return NO;
    
    if ([Self_Decimal compare:Param_Decimal(decimalString)] == NSOrderedSame ) {
        return YES;
    }
    return NO;
}

- (BOOL)isGreaterThanDecimalString:(NSString *)decimalString
{
    InvalidCalculate(decimalString) return NO;
    if ([Self_Decimal compare:Param_Decimal(decimalString)] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)isSmallerThanDecimalString:(NSString *)decimalString
{
    InvalidCalculate(decimalString) return NO;
    if ([Self_Decimal compare:Param_Decimal(decimalString)] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

- (NSString *)formatDecimalString:(NSUInteger)scale round:(BOOL)isRound
{
    if ([self length] == 0) {
        return @"";
    }
    NSRoundingMode mode = isRound ? NSRoundPlain : NSRoundDown;
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                                      scale:scale
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *result = [Self_Decimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [result stringValue];
}

- (NSString *)formatPointString:(NSUInteger)scale
{
    if ([self length] == 0) {
        return @"";
    }
    NSString *fString = [NSString stringWithFormat:@"%%.%ldf",scale];
    NSString *hString = [NSString stringWithFormat:fString, [self doubleValue]];
    return hString;
}






@end
