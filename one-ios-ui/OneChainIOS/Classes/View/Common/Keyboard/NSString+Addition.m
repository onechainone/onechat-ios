//
//  NSString+Addition.m
//  pet
//
//  Created by 韩绍卿 on 2017/7/28.
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
    
    if( pictureStr == nil ) return nil;
    
    // NSString *URLStr = [@"http://testavatar2.yuyin365.com:18081/" stringByAppendingString:pictureStr];
    
    // [OneContext.avatarServerUrl stringByAppendingString:pictureStr];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@/%@",[ONEUrlHelper userAvatarPrefix],pictureStr];
    
    
    return URLStr;
}
+(NSString *)addMoneyIconURLStr:(NSString *)moneyIconStr {
    if (moneyIconStr) {
    
        // NSString *URLStr = [@"http://testimage2.yuyin365.com:80/" stringByAppendingString:moneyIconStr];
        
        // [OneContext.imageServerUrl stringByAppendingString:moneyIconStr];
        
        NSString *URLStr = [NSString stringWithFormat:@"%@/%@",[ONEUrlHelper assetIconImagePrefix], moneyIconStr];

        return URLStr;
    }

    return @"";
}
+ (NSString *) compareCurrentTime:(NSString *)str
{
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
}
- (NSString *)updateTimeForRow:(NSString *)createTimeString {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec<60) {
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

@end
