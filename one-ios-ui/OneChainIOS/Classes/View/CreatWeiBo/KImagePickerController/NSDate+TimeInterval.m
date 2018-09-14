
//
//  NSDate+TimeInterval.m
//  CancerDo
//
//  Created by hugaowei on 16/6/13.
//  Copyright © 2016年 lianji. All rights reserved.
//


#import "NSDate+TimeInterval.h"

@implementation NSDate (TimeInterval)

+ (NSDateComponents*)componetsWithTimeInterval:(NSTimeInterval)timeInterval{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    
    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)components.hour,components.minute,components.second];
    }else{
        return  [NSString stringWithFormat:@"%ld:%02ld",(long)components.minute,components.second];
    }
}


@end
