//
//  NSString+Addition.m
//  pet
//
//  Created by 王玉朝 on 2017/7/28.
//  Copyright © 2017年 hanshaoqing. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

//字典转为Json字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (NSString *)addURLStr:(NSString *)pictureStr{
    
    NSString *URLStr = [@"http://47.95.239.122" stringByAppendingString:pictureStr];
    
    return URLStr;
}
@end
