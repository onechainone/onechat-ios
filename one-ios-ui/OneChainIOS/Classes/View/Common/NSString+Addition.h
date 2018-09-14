//
//  NSString+Addition.h
//  pet
//
//  Created by 王玉朝 on 2017/7/28.
//  Copyright © 2017年 hanshaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
//字典转为Json字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dic;

//字符串拼接图片下载网址
+ (NSString *)addURLStr:(NSString *)pictureStr;
@end
