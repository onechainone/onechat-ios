//
//  NSString+Addition.h
//  pet
//
//  Created by 韩绍卿 on 2017/7/28.
//  Copyright © 2017年 hanshaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
//字典转为Json字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dic;

//字符串拼接图片下载网址
+ (NSString *)addURLStr:(NSString *)pictureStr;
///字符串拼接钱币头像
+ (NSString *)addMoneyIconURLStr:(NSString *)moneyIconStr;
///分秒的
+ (NSString *) compareCurrentTime:(NSString *)str;
//时间戳的
+(NSString *)updateTimeForRow:(NSString *)createTimeString;

@end
