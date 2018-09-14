//
//  CoinTools.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/13.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "CoinTools.h"

#import <WalletCore/WSBigNumber.h>
#import "Reachability.h"
#import "PreRegisterController.h"

#define DEV_PASSWORD_TIME 20

#define RELEASE_PASSWORD_TIME 7200

@implementation CoinTools{
    
        dispatch_source_t _timer;
}
    

    

//单例
+ (instancetype)sharedCoinTools{
    
    static CoinTools *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        self.inCount = 1;
        client = [[self alloc]init];
    });
    
    return client;
}
-(NSString *)getExactNumWithStr:(NSString *)string andPrecision:(int)precision {
    
    NSString *str = @".";
    if ([string rangeOfString:str].location != NSNotFound) {
        
        //NSLog(@"这个字符串中有.");
        NSArray *array = [string componentsSeparatedByString:@"."]; //从字符.中分隔成2个元素的数组
        if ([array[1] length] > precision) {
            NSString *pointStr = array[1];
            pointStr = [pointStr substringToIndex:precision];
            NSString *realStr = [NSString stringWithFormat:@"%@.%@",array[0],pointStr];
            return realStr;
        }
    } else {
        return string;
    }
    return string;
    
}
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText];
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            if (0 == i) {
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }else
            {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            }else
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

+(NSString*) creditAssetWithDict:(NSMutableDictionary*) dict {
    
    NSString* ret = @"0";
    
    //等于空的时候retrun
    if(dict == nil ) {
        
        return ret;
    }
    
    
    id amount = [dict objectForKey:BALANCE_AMOUNT];
    
    if( dict == nil ) {
        
        return ret;
    }
    
    NSString* ta = nil;
    
    if( [amount isKindOfClass:[NSNumber class]] ) {
        
        NSNumber* na = amount;
        
        ta = [na stringValue];
        
    } else {
        
        ta = amount;
    }
    
    
    //这个方法传 精度和个数
    
    NSNumber* p = [dict objectForKey:BALANCE_PRECISION];
    
    if( p == nil ) {
        
        return ret;
    }
    
    int  min_prece = [p intValue];
    
    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:ta];
//    WSBigNumber *temp = [[WSBigNumber alloc] initWithDecimalString:@"100"];
    
    NSString* strAmount =  [n stringWithRShiftDec:min_prece];
    
    return strAmount;
    
}
- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    return preferredLang;
}

///时间戳
- (NSString *)updateTimeForRow:(NSString *)createTimeString {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec == 0) {
        //NSDateCategory.text8 刚刚
        return NSLocalizedString(@"NSDateCategory.text8", nil);
    }
    if (sec<60) {
        //分钟前 NSDateCategory.text2 NSLocalizedString(@"NSDateCategory.text2", nil)
        return [NSString stringWithFormat:@"%ld%@",sec,NSLocalizedString(@"NSDateCategory.text2", nil)];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        //小时前 NSDateCategory.text3
        return [NSString stringWithFormat:@"%ld%@",hours,NSLocalizedString(@"NSDateCategory.text3", nil)];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        
        if (days == 1) {
            //昨天
            return NSLocalizedString(@"NSDateCategory.text7", nil);
        }else {
            //天前NSDateCategory.text4
            return [NSString stringWithFormat:@"%d%@",days,NSLocalizedString(@"NSDateCategory.text4", nil)];
        }
    }
    
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        // 月前NSDateCategory.text5
        return [NSString stringWithFormat:@"%ld%@",months,NSLocalizedString(@"NSDateCategory.text5", nil)];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    //年前
    return [NSString stringWithFormat:@"%ld%@",years,NSLocalizedString(@"NSDateCategory.text6", nil)];
    
}
- (NSString *)judgeNetWork {

    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NSString * tips = @"";
    
//    switch (reach.currentReachabilityStatus)
//    {

//        case NotReachable:
//            tips = @"无网络连接";
//            return tips;
////ReachableViaWiFi
//        case ReachableViaWiFi:
//            tips = @"Wifi";
//            return tips;
//
//        case ReachableViaWWAN:
//            NSLog(@"移动流量");
//
//    }
    //            /*
    //             NotReachable = 0,
    //             ReachableViaWiFi = 2,
    //             ReachableViaWWAN = 1
    //             */
    if (reach.currentReachabilityStatus == NotReachable) {
        return @"NO";
    } else {
        return @"YES";
    }

}
- (void)saveuserArrInfo:(id)userArrInfo name:(NSString *)name{
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2、添加储存的文件名
    NSString *path  = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",name]];
    //3、将一个对象保存到文件中
    [NSKeyedArchiver archiveRootObject:userArrInfo toFile:path];
}
-(void)deleteUserInfo:(NSString *)name {
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2、添加储存的文件名
    NSString *path  = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",name]];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL bRet = [fileMgr fileExistsAtPath:path];
    if (bRet) {
        //
        NSError *err;
        
        [fileMgr removeItemAtPath:path error:&err];
    }
    
}
-(NSString *)jugmentIphoneLanguage {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] && ![[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""]) {
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE]];
    }
    
    return @"";
}
//7200s
-(void)startTimerWithSecond:(double)time {
    // GCD定时器
//    static dispatch_source_t _timer;
//    NSTimeInterval period = time; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0); //每秒执行
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        int hours = self.timeCount / 3600;
        int minutes = (self.timeCount - (3600*hours)) / 60;
        int seconds = self.timeCount%60;
        
        dispatch_async(dispatch_get_main_queue(), ^{
//#if  as_is_dev_mode
            NSInteger userTime = RELEASE_PASSWORD_TIME;
//            NSLog(@"123");
            self.timeCount++;
            if (seconds == userTime) {
                //到时间就需要输入密码了
                //            [[CoinTools sharedCoinTools] saveuserArrInfo:@"YES" name:@"isNeedWritePassword"];
                [[CoinTools sharedCoinTools] deleteUserInfo:@"isNeedWritePassword"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:nil];
                
                NSLog(@"2个小时了");
                dispatch_source_cancel(_timer);
                _timeCount = 0;
//#endif
                
//                NSInteger userTime = RELEASE_PASSWORD_TIME;
//                NSLog(@"123");
//                self.timeCount++;
//                if (seconds == userTime) {
//                    //到时间就需要输入密码了
//                    //            [[CoinTools sharedCoinTools] saveuserArrInfo:@"YES" name:@"isNeedWritePassword"];
//                    [[CoinTools sharedCoinTools] deleteUserInfo:@"isNeedWritePassword"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:nil];
//
//                    NSLog(@"2个小时了");
//                    dispatch_source_cancel(_timer);
//                    _timeCount = 0;

                
            }

        });

    });

    // 开启定时器
    dispatch_resume(_timer);

}
-(void)stopTimer {
    if (!_timer) {
        [[CoinTools sharedCoinTools] deleteUserInfo:@"isNeedWritePassword"];
    } else {
        dispatch_source_cancel(_timer);
    }
}
-(BOOL)copyToPasteboardWithString:(NSString *)str {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = str;
    
    if ([pasteBoard.string isEqualToString:str]) {
        return YES;
    } else {
        return NO;
    }
    
    
}

/*if (UIImagePNGRepresentation(_picView.image) == nil) {
 
 
 data = UIImageJPEGRepresentation(_picView.image, 1);
 
 
 }
 else {
 data = UIImagePNGRepresentation(_picView.image);
 }
 */
//-(BOOL)copyToPasteboardWithImg:(UIImage *)img {

//    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//    pasteBoard.image = img;
//    
//    if (UIImagePNGRepresentation(img) == nil) {
//     
//     data = UIImageJPEGRepresentation(img, 1);
//        return NO;
//        
//     }
//     else {
//         data1 = UIImagePNGRepresentation(img);
//         data2 = UIImagePNGRepresentation(pasteBoard.image);
////         if (data1) {
////             <#statements#>
////         }
//         return nil;
//     }
     
//}
-(NSString *)siSheWuRuWith:(NSString *)str andJingDu:(int)num {
    if (!str) {
        return @"0";
    }
//    if (num == nil) {
//        return @"0";
//    }
//    NSDecimalNumber *total = [NSDecimalNumberdecimalNumberWithString:str];
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:str];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       
                                       scale:num
                                       
                                       raiseOnExactness:NO
                                       
                                       raiseOnOverflow:NO
                                       
                                       raiseOnUnderflow:NO
                                       
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *decimal = [total decimalNumberByRoundingAccordingToBehavior:roundUp];
    
    return [decimal stringValue];
    
}
//+(BOOL)isRuiNian {
//    
//    if ((year%4==0 && year %100 !=0) || year%400==0) {
//        return YES;
//    }else {
//        return NO;
//    }
//    return NO;
//}
//-(void)isNeedVerifySeedWithcontroller:(UIViewController *)target{
//    
//}
-(void)showVerifySeedControllerWithcontroller:(UIViewController *)target{
    PreRegisterController *preVC = [PreRegisterController new];
    preVC.VerifySeed = @"1";
    
    [target.navigationController pushViewController:preVC animated:YES];
//    [target presentViewController:preVC animated:YES completion:^{
//
//    }];
    
}
-(NSAttributedString *)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    return str;
    
}
-(NSString *)cutStr:(NSString *)str andjianGeFu:(NSString *)jiangeStr andGeShu:(int)num{
    
    NSArray *b = [str componentsSeparatedByString:jiangeStr];
    NSString *a3 = [b objectAtIndex:num];
    
    return a3;
    
}
-(NSString *)accordingGeLinShiJiangetJingQueStr:(NSString *)time{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *date = [format dateFromString:time];
    
    //设置源日期时区
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    
    //目标日期与本地时区的偏移量
    
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    
    //得到时间偏移量的差值
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    NSString *str = [format stringFromDate:destinationDateNow];
    NSString *time1 = [str substringFromIndex:5];
    NSString *time3 = [time1 substringToIndex:11];
    NSString *time2 = [time3 stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return time2;
    
}
-(NSString *)accordingGeLinShiJianGetQuanBuJingQueStr:(NSString *)time{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *date = [format dateFromString:time];
    
    //设置源日期时区
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    
    //目标日期与本地时区的偏移量
    
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    
    //得到时间偏移量的差值
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    NSString *str = [format stringFromDate:destinationDateNow];
//    NSString *time1 = [str substringFromIndex:5];
//    NSString *time3 = [time1 substringToIndex:11];
//    NSString *time2 = [time3 stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return str;
    
}
-(long)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    //Asia/Shanghai
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
    
}

-(NSDecimalNumber *)decimalYiWeiWithStr:(NSNumber *)str andJingDu:(NSNumber *)JingDu{
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",str]];
//    int i = 10*[JingDu intValue];
//    NSNumber *zhiShu = [[NSNumber alloc] initWithInt:i];
////    NSNumber
//   NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:[zhiShu stringValue]];
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"10"];
//    NSDecimalNumber *number2 = [number decimalNumberByMultiplyingByPowerOf10:JingDu];
    
    NSDecimalNumber *num = [number decimalNumberByRaisingToPower:[JingDu intValue]];

    NSDecimalNumber *temp = [number1 decimalNumberByDividingBy:num];
    return temp;
    
}
-(void)labelSetTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];

    label.attributedText = str;
}

-(void)sychorinizeAddressBookWith:(UIViewController *)target andBlock:(sysBlock)block{
//    [target showHudInView:target.view hint:nil];
//    __weak typeof(self) weakself = self;
    
    
}

- (void)showAlertWith:(UIViewController *)target andMsg:(NSString *)str
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(str, @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [target presentViewController:alert animated:YES completion:nil];
}


-(int)timeCount {
    
    if (!_timeCount) {
        _timeCount = 0;
    }
    return _timeCount;
}
@end
