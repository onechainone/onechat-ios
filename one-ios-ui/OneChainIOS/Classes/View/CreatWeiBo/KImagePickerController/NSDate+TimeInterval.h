
//
//  NSDate+TimeInterval.h
//  CancerDo
//
//  Created by hugaowei on 16/6/13.
//  Copyright © 2016年 lianji. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (TimeInterval)


+ (NSDateComponents*)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end
