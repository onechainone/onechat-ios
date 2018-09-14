//
//  MTool.m
//  ChatDemo
//
//  Created by hugaowei on 16/5/21.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "MTool.h"
//#import "RequestSuccessView.h"
//#import "RequestFailedView.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#define NetworkingWaitingViewTag 12345
#define WrongAlertViewTag        12346
#define RequestSuccessTag        12347
#define RequestFailedTag         12348

NSString *const UserInformation_Plist = @"userInformation.plist";
NSString *const UserInformation       = @"userInfor";
NSString *const Note_Configure        = @"suishouji";

@interface MTool () <CLLocationManagerDelegate>

//@property (nonatomic, copy) GetCityBlock cityBlock;
//@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MTool

//- (void)getCurrentLocation:(GetCityBlock)cityBlock {
//    _cityBlock = cityBlock;
//
//    if ([CLLocationManager locationServicesEnabled]) {
//        //        CLog(@"--------开始定位");
//        self.locationManager = [[CLLocationManager alloc]init];
//        self.locationManager.delegate = self;
//        //控制定位精度,越高耗电量越
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//        // 总是授权
//        [self.locationManager requestAlwaysAuthorization];
//        //distanceFilter表示更新位置的距离，假如超过设定值则进行定位更新，否则不更新
//        //self.locationManager.distanceFilter = kCLDistanceFilterNone表示不设置距离过滤，即随时更新地理位置。
//        self.locationManager.distanceFilter = kCLDistanceFilterNone;//10.0f;
//        //        [self.locationManager requestAlwaysAuthorization];
//        [self.locationManager startUpdatingLocation];
//    } else {
//        _cityBlock(@"未知");
//        NSLog(@"没有打开位置信息服务");
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    [manager stopUpdatingLocation];
//
//    if ([error code] == kCLErrorDenied) {
//        _cityBlock(@"未知");
//        NSLog(@"访问被拒绝");
//    }
//    if ([error code] == kCLErrorLocationUnknown) {
//        _cityBlock(@"未知");
//        NSLog(@"无法获取位置信息");
//    }
//
//}
////定位代理经纬度回调
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
//
//    CLLocation *newLocation = locations[0];
//
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
//        if (array.count > 0){
//            CLPlacemark *placemark = [array objectAtIndex:0];
//
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//            }
//            NSLog(@"city = %@", city);
//
//            _cityBlock(city);
//        }
//        else if (error == nil && [array count] == 0)
//        {
//            _cityBlock(@"未知");
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil)
//        {
//            _cityBlock(@"未知");
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
//
//}
//
//+ (UIView *)groupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor {
//
//    UIView *iconView = [[UIView alloc] init];
//    UIColor *backgroundColor = [bgColor isEqual:nil] ? [UIColor clearColor] : bgColor;
//    iconView.backgroundColor = backgroundColor;
//    if (array.count >= 2) {
//
//        NSArray *rects = [self eachRectInGroupWithCount:(int)array.count];
//        int count = 0;
//        for (id obj in array) {
//
//            if (count > rects.count-1) {
//                break;
//            }
//
//            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
//
//            if ([obj isKindOfClass:[NSString class]]) {
//                NSString *imageURL = (NSString *)obj;
//                if ([imageURL hasPrefix:@"http"]) {
//                    NSURL *url = [NSURL URLWithString:imageURL];
//                    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiangfangnan"]];
//                } else {
//                    UIImage *image = [UIImage imageNamed:imageURL];
//                    imageView.image = image;
//                }
//            } else if ([obj isKindOfClass:[UIImage class]]){
//                UIImage *image = (UIImage *)obj;
//                imageView.image = image;
//            } else {
//                NSLog(@"%s Unrecognizable class type", __FUNCTION__);
//                break;
//            }
//
//            [iconView addSubview:imageView];
//            count++;
//        }
//    }
//
//    return iconView;
//}
//
//+ (NSArray *)eachRectInGroupWithCount:(int)count {
//
//    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
//
//    CGFloat sizeValue = 80;
//    CGFloat padding = 5;
//
//    CGFloat eachWidth;
//
//    if (count <= 4) {
//        eachWidth = (sizeValue - padding*3) / 2;
//        [self getRects:array padding:padding width:eachWidth count:4];
//    } else {
//        padding = padding / 2;
//        eachWidth = (sizeValue - padding*4) / 3;
//        [self getRects:array padding:padding width:eachWidth count:9];
//    }
//
//    if (count < 4) {
//        [array removeObjectAtIndex:0];
//        CGRect rect = CGRectFromString([array objectAtIndex:0]);
//        rect.origin.x = (sizeValue - eachWidth) / 2;
//        [array replaceObjectAtIndex:0 withObject:NSStringFromCGRect(rect)];
//        if (count == 2) {
//            [array removeObjectAtIndex:0];
//            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
//
//            for (NSString *rectStr in array) {
//                CGRect rect = CGRectFromString(rectStr);
//                rect.origin.y -= (padding+eachWidth)/2;
//                [tempArray addObject:NSStringFromCGRect(rect)];
//            }
//            [array removeAllObjects];
//            [array addObjectsFromArray:tempArray];
//        }
//    } else if (count != 4 && count <= 6) {
//        [array removeObjectsInRange:NSMakeRange(0, 3)];
//        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:6];
//
//        for (NSString *rectStr in array) {
//            CGRect rect = CGRectFromString(rectStr);
//            rect.origin.y -= (padding+eachWidth)/2;
//            [tempArray addObject:NSStringFromCGRect(rect)];
//        }
//        [array removeAllObjects];
//        [array addObjectsFromArray:tempArray];
//
//        if (count == 5) {
//            [tempArray removeAllObjects];
//            [array removeObjectAtIndex:0];
//
//            for (int i=0; i<2; i++) {
//                CGRect rect = CGRectFromString([array objectAtIndex:i]);
//                rect.origin.x -= (padding+eachWidth)/2;
//                [tempArray addObject:NSStringFromCGRect(rect)];
//            }
//            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
//        }
//
//    } else if (count != 4 && count < 9) {
//        if (count == 8) {
//            [array removeObjectAtIndex:0];
//            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
//            for (int i=0; i<2; i++) {
//                CGRect rect = CGRectFromString([array objectAtIndex:i]);
//                rect.origin.x -= (padding+eachWidth)/2;
//                [tempArray addObject:NSStringFromCGRect(rect)];
//            }
//            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
//        } else {
//            [array removeObjectAtIndex:2];
//            [array removeObjectAtIndex:0];
//        }
//    }
//
//    return array;
//}
//
//+ (void)getRects:(NSMutableArray *)array padding:(CGFloat)padding width:(CGFloat)eachWidth count:(int)count {
//
//    for (int i=0; i<count; i++) {
//        int sqrtInt = (int)sqrt(count);
//        int line = i%sqrtInt;
//        int row = i/sqrtInt;
//        CGRect rect = CGRectMake(padding * (line+1) + eachWidth * line, padding * (row+1) + eachWidth * row, eachWidth, eachWidth);
//        [array addObject:NSStringFromCGRect(rect)];
//    }
//}
//
//
//+(UIFont*)tabBarFontAccordingDevice{
//
//    if (iPhone6 || iPhonePlus) {
//        return [UIFont systemFontOfSize:11.0f];
//    }
//
//    return [UIFont systemFontOfSize:10.0f];
//}
//
//+(UIFont*)navigationBarTitleFont{
//    if (iPhone5) {
//        return [UIFont systemFontOfSize:19.0f];
//    }
//
//    if (iPhone6) {
//        return [UIFont systemFontOfSize:20.0f];
//    }
//
//    if (iPhonePlus) {
//        return [UIFont systemFontOfSize:21.0f];
//    }
//
//    return [UIFont systemFontOfSize:17.0f];
//}
//
+(UIFont*)navigationItemFont{
    if (iPhone5) {
        return [UIFont systemFontOfSize:14.0f];
    }

    if (iPhone6) {
        return [UIFont systemFontOfSize:16.0f];
    }

    if (iPhonePlus) {
        return [UIFont systemFontOfSize:16.0f];
    }

    return [UIFont systemFontOfSize:12.0f];
}
//
//#pragma mark 判断手机号码是否规则
//+ (BOOL)isMobileNumber:(NSString *)mobileNum
//{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//
//    NSString *oness = @"^1[3|4|5|7|8][0-9]{9}$";
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestoness = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", oness];
//
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES)
//        || ([regextestoness evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//+(BOOL)checkCurrentNetState{
//
//    Reachability  *hostReach = [Reachability reachabilityWithHostname:@"http://www.xiangsibang.com"];
//    if (hostReach.currentReachabilityStatus == NotReachable) {
//        return NO;
//    }
//
//    return YES;
//}
//
//+(void)showNoNetAlert{
//
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
//    [appDelegate.window addSubview:HUD];
//    HUD.labelText = @"网络好像有点问题";
//    HUD.mode = MBProgressHUDModeCustomView;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//    }];
//}
//
///*
// *  如果typeStr为nil，或者为空，filename是一个单独的file,否则filename是一个公用的file
// */
//+(void)saveData:(NSDictionary*)dict forType:(NSString *)typeStr  filePath:(NSString*)fileName{
//
//    if (typeStr == nil) {
//        typeStr = @"";
//    }
//
//    NSString *filePath = [MTool getDocumentPahtWithSuffix:fileName];
//
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if (![fm fileExistsAtPath:filePath]) {
//        [fm createFileAtPath:filePath contents:nil attributes:nil];
//    }
//
//    NSMutableDictionary *dictonary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
//    if (!dictonary) {
//        dictonary = [NSMutableDictionary dictionary];
//    }
//
//    if ([typeStr isBlankString]) {
//        [dict writeToFile:filePath atomically:YES];
//    }else{
//        [dictonary setObject:dict forKey:typeStr];
//        [dictonary writeToFile:filePath atomically:YES];
//    }
//}
//
//
///*
// * 如果typeStr为nil，或者为空，filename是一个单独的file,否则filename是一个公用的file
// */
//+(NSDictionary*)readDataFromPlistFile:(NSString*)fileName withType:(NSString*)typeStr{
//
//    NSString *filePath = [MTool getDocumentPahtWithSuffix:fileName];
//    NSFileManager *fm = [NSFileManager defaultManager];
//
//    if (![fm fileExistsAtPath:filePath]) {
//        return nil;
//    }
//
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//
//    if ([typeStr isBlankString]) {
//        return dict;
//    }else{
//        if ([dict objectForKey:typeStr]) {
//            id sender = [dict objectForKey:typeStr];
//            if ([sender isKindOfClass:[NSDictionary class]]) {
//                return (NSDictionary*)sender;
//            }
//        }
//    }
//
//    return nil;
//}
//
//+(NSString *)getDocumentPahtWithSuffix:(NSString*)suffixStr{
//
//    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:suffixStr];
//}
//
//+(NSString*)getYearMonthDayFromString:(NSString*)str{//把时间xxxx-xx-xx xx:xx 转换成 xxxx年xx月xx日 xx:xx
//
//    NSArray *timeArr = [str componentsSeparatedByString:@" "];
//    NSString *timeStr1 = @"";
//    NSString *dateStr = @"";
//    if (timeArr.count == 2) {
//        timeStr1 = [timeArr lastObject];
//        dateStr = [timeArr firstObject];
//
//        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
//        if (dateArr.count == 3) {
//            dateStr = [dateArr firstObject];
//            dateStr = [dateStr stringByAppendingString:@"年"];
//
//            NSString *monthStr = [dateArr objectAtIndex:1];
//            if ([monthStr hasPrefix:@"0"]) {
//                monthStr = [[monthStr componentsSeparatedByString:@"0"] lastObject];
//            }
//
//            dateStr = [dateStr stringByAppendingString:monthStr];
//            dateStr = [dateStr stringByAppendingString:@"月"];
//            NSString *riStr = [dateArr lastObject];
//            if ([riStr hasPrefix:@"0"]) {
//                riStr = [[riStr componentsSeparatedByString:@"0"] lastObject];
//            }
//
//            dateStr = [dateStr stringByAppendingString:riStr];
//            dateStr = [dateStr stringByAppendingString:@"日"];
//        }
//
//    }else{
//        dateStr = str;
//    }
//
//    return [NSString stringWithFormat:@"%@  %@",dateStr,timeStr1];
//}
//
+ (void)showWrongAlertViewWithMessage:(NSString*)message viewController:(UIViewController*)viewController{

    if (IOS8) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        [alertController addAction:action];
//        [viewController presentViewController:alertController animated:YES completion:nil];
        [[UIAlertController shareAlertController] showAlertcWithString:message controller:viewController];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSDefLocalizedString(@"message_title") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"button_ok", nil) otherButtonTitles: nil];
        [alertView show];
    }
}

+(void)showLoginAlertView:(UIViewController *)controller withSelector:(SEL)selector{
//    if (IOS8) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"由于您的账号长期没有登录或是在其他设备登录，需要您重新登录" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if (selector && [controller respondsToSelector:selector]) {
//                [controller performSelector:selector withObject:nil];
//            }
//        }];
//        [alertController addAction:action];
//        [controller presentViewController:alertController animated:YES completion:nil];
//    }else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"由于您的账号长期没有登录或是在其他设备登录，需要您重新登录" delegate:controller cancelButtonTitle:@"重新登录" otherButtonTitles: nil];
//        alertView.tag = LoginFirst;
//        [alertView show];
//    }
}
//
+(CGRect)getFrameWithString:(NSString*)str size:(CGSize)size font:(UIFont*)font{

    if ([str isBlankString]) {
        return CGRectZero;
    }

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paraStyle,NSParagraphStyleAttributeName, nil];

    CGRect frame = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

    return frame;
}

//+ (CGRect)getFrameWithString:(NSString *)string withSize:(CGSize)size withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing {
//
//    if ([string isBlankString]) {
//        return CGRectZero;
//    }
//
//    //1.1最大允许绘制的文本范围
//
//    //1.2配置计算时的行截取方法,和contentLabel对应
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:lineSpacing];
//    style.lineBreakMode = NSLineBreakByCharWrapping;
//
//    //1.3配置计算时的字体的大小
//    //1.4配置属性字典
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
//    //2.计算
//    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
//    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
//
//    return rect;
//}
//
+(void)showNetworkingWaitingViewWithTitle:(NSString*)title{
//    AppDelegate *appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NetworkingAlertView *view = (NetworkingAlertView*)[appDelegate.window viewWithTag:NetworkingWaitingViewTag];
//    if (view == nil) {
//        view = [[NetworkingAlertView alloc] init];
//        view.tag = NetworkingWaitingViewTag;
//        [appDelegate.window addSubview:view];
//    }
//    view.title = title;
//    [view show];
    NSLog(@"等待");
    
}
//
+(void)networkingWaitingViewHidden{
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NetworkingAlertView *view = (NetworkingAlertView*)[appDelegate.window viewWithTag:NetworkingWaitingViewTag];
//    if (view) {
////        [view dismiss];
//        [view removeFromSuperview];
//    }
    NSLog(@"HIDDEN");
    
}
//
//+(void)showNetworkingWrongViewWithTitle:(NSString*)title{
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NetworkingWrongAlertView *view = (NetworkingWrongAlertView*)[appDelegate.window viewWithTag:WrongAlertViewTag];
//    if (view == nil) {
//        view = [[NetworkingWrongAlertView alloc] init];
//        view.tag = WrongAlertViewTag;
//        [appDelegate.window addSubview:view];
//    }
//    view.title = title;
//    [view show];
//}
//
//+(CGRect)getAdjustFrame:(CGRect)frame{
//
//    CGFloat ScaleX = 1.0;
//    CGFloat ScaleY = 1.0;
//
//    CGRect rect = CGRectZero;
//
//    if(ScreenHeight > 480){
//
//        ScaleX = ScreenWidth/320.0;
//
//        ScaleY = ScreenHeight/568.0;
//    }
//
//    rect.origin.x = ScaleX *frame.origin.x;
//    rect.origin.y = ScaleY *frame.origin.y;
//
//    rect.size.width  = ScaleX *frame.size.width;
//    rect.size.height = ScaleY *frame.size.height;
//
//    return rect;
//}
//
//+(void)login:(UIViewController*)viewController{
//    [[UserInforModel sharedUserInfor] loginOut];
//
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//
//    if (appDelegate.kTabBarController) {
//        UIViewController *vc2 = [appDelegate.kTabBarController.navigationController.viewControllers lastObject];
//        if (vc2) {
//            appDelegate.conversatinListController = nil;
//            appDelegate.kTabBarController = nil;
//            [UIView animateWithDuration:0.25 animations:^{
//                vc2.navigationController.view.transform = CGAffineTransformMakeScale(2, 2);
//                vc2.navigationController.view.alpha = 0;
//            } completion:^(BOOL finished) {
//                vc2.navigationController.view.transform = CGAffineTransformMakeScale(1, 1);
//                LoginViewController *loginViewController = [[LoginViewController alloc] init];
//                appDelegate.window.rootViewController = [[KBaseNavigationController alloc] initWithRootViewController:loginViewController];
//            }];
//        }else{
//            appDelegate.conversatinListController = nil;
//            appDelegate.kTabBarController = nil;
//            LoginViewController *loginViewController   = [[LoginViewController alloc] init];
//            appDelegate.window.rootViewController = [[KBaseNavigationController alloc] initWithRootViewController:loginViewController];
//        }
//    }else{
//        appDelegate.conversatinListController = nil;
//        appDelegate.kTabBarController = nil;
//        LoginViewController *loginViewController   = [[LoginViewController alloc] init];
//        appDelegate.window.rootViewController = [[KBaseNavigationController alloc] initWithRootViewController:loginViewController];
//    }
//}
//
//+(void)showRequestSuccessAlert:(NSString*)content inView:(UIView*)view{
//    if (view == nil || content == nil || [content isBlankString]) {
//        return;
//    }
//
//    RequestSuccessView *showView = (RequestSuccessView*)[view viewWithTag:RequestSuccessTag];
//    if (showView == nil) {
//        showView = [[RequestSuccessView alloc] init];
//        showView.tag = RequestSuccessTag;
//        [view addSubview:showView];
//    }
//
//    showView.title = content;
//}
//
//+(void)showRequestFailedAlert:(NSString*)content inView:(UIView*)view{
//    if (view == nil || content == nil || [content isBlankString]) {
//        return;
//    }
//
//    RequestFailedView *showView = (RequestFailedView*)[view viewWithTag:RequestFailedTag];
//    if (showView == nil) {
//        showView = [[RequestFailedView alloc] init];
//        showView.tag = RequestFailedTag;
//        [view addSubview:showView];
//    }
//
//    showView.title = content;
//}
//
//+(NSString*)getDateStringFromDate:(NSDate*)date{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
////    NSString *theDay = [dateFormatter stringFromDate:date];//日期的年月日
////    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
//
//    NSTimeInterval timeInterval = -[date timeIntervalSinceNow];
//    if (timeInterval < 60.0) {// 1分钟内
//        return @"刚刚";
//    } else if (timeInterval < (60.0*60.0) && (timeInterval >= 60.0f)) {//1小时内
//        NSInteger timeM = timeInterval / 60.0;
//        return [NSString stringWithFormat:@"%ld分钟前", (long)timeM];
//    } else if ((timeInterval < (24*60.0*60.0)) && (timeInterval>=(60.0*60.0))) {//24小时内
//        NSInteger timeH = timeInterval / (60*60);
//        return [NSString stringWithFormat:@"%ld小时前", (long)timeH];
//    } else if ((timeInterval < (7*24*60.0*60.0)) && (timeInterval >= (24*60.0*60.0))){
//        NSInteger timeH = (NSInteger)(timeInterval / (24*60.0*60.0));
//        return [NSString stringWithFormat:@"%ld天前", (long)timeH];
//
////    }else if ([theDay isEqualToString:currentDay]) {//当天
////        [dateFormatter setDateFormat:@"HH:mm"];
////        return [NSString stringWithFormat:@"今天%@", [dateFormatter stringFromDate:date]];
////    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
////        [dateFormatter setDateFormat:@"HH:mm"];
////        return [NSString stringWithFormat:@"昨天%@", [dateFormatter stringFromDate:date]];
//    }else {//以前
////        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        return [dateFormatter stringFromDate:date];
//    }
//
//    return @"";
//}
//
//+(NSString*)getDateStringFromDateBefore:(NSDate*)date{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSDateFormatter *tommoryFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM月dd日"];
//    [tommoryFormatter setDateFormat:@"HH:mm"];
//
//    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
//
//    // 当前日期
//    int currentDate = [self getIntegerFromDate:[NSDate date]];
//    // 目标日期
//    int tar = [self getIntegerFromDate:date];
//    // 时间差
//    int diff = tar - currentDate;
//
//    if (timeInterval < 60.0) {// 1分钟内
//        return @"一分钟内";
//    } else if (timeInterval < (60.0*60.0) && (timeInterval >= 60.0f)) {//1小时内
//        NSInteger timeM = timeInterval / 60.0;
//        return [NSString stringWithFormat:@"%ld分钟后", (long)timeM];
//    } else if ((timeInterval < (24*60.0*60.0)) && (timeInterval>=(60.0*60.0))) {//24小时内
//
//        if (diff == 1) {
//
//            NSString *dateStr = [tommoryFormatter stringFromDate:date];
//            return [NSString stringWithFormat:@"明天%@",dateStr];
//        } else {
//
//            NSString *dateStr = [tommoryFormatter stringFromDate:date];
//            return [NSString stringWithFormat:@"今天%@",dateStr];
//        }
//    }else {//以前
//        return [dateFormatter stringFromDate:date];
//    }
//
//    return @"";
//}
//
//+ (int)getIntegerFromDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyyMMdd"];
//    NSString *todayStr = [formatter stringFromDate:date];
//    int presentDay = [todayStr intValue];
//    return presentDay;
//}
//
//+(NSString*)getCountdownFromDateBefore:(NSDate*)date{
//
//    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
//    NSInteger time = (NSInteger)timeInterval;
//    if (time < 0) {//
//        return [NSString stringWithFormat:@"即将开始"];
//    } else if (time < 60) {// 1分钟内
//        return [NSString stringWithFormat:@"%ld秒",(long)time];
//    } else if (timeInterval < (60 *60) && (timeInterval >= 60)) {//1小时内
//        NSInteger timeM = time / 60;
//        NSInteger timeS = time % 60;
//        return [NSString stringWithFormat:@"%ld分%ld秒", (long)timeM,(long)timeS];
//    } else if ((timeInterval < (24 * 60 * 60)) && (timeInterval>=(60 *60))) {//24小时内
//
//        NSInteger timeH = time / (60 * 60);
//        NSInteger timeM = (time % (60 * 60)) / 60;
//        NSInteger timeS = time % 60;
//        return [NSString stringWithFormat:@"%ld小时%ld分%ld秒", (long)timeH,(long)timeM,(long)timeS];
//    }else {//以前
//
//        NSInteger timeD = time / (24 * 60 * 60);
//        NSInteger timeH = (time % (24 * 60 * 60)) / (60 * 60);
//        NSInteger timeM = (time % (60 * 60)) / 60;
//        NSInteger timeS = time % 60;
//        return [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒", (long)timeD,(long)timeH,(long)timeM,(long)timeS];
//    }
//
//    return @"";
//}
//
//+(void)sharedAppToOtherPlatFormInViewController:(UIViewController*)viewController{
//    NSString *sharedURLString   = @"http://www.xiangsibang.com/app/dowload.php";
////    NSString *sharedTitleString = @"相似病友一起“度”癌";
//    NSString *sharedTitleString = @"相似病友一起度癌";
//
//    UserInforModel *userModel = [UserInforModel sharedUserInfor];
//
////我在癌度的船上，邀请您一起来“度”癌，上船的口令是
//    NSString *sharedContent = [NSString stringWithFormat:@"自助者天助,“度”癌用癌度! 邀请码：%@",userModel.uid];
//
//    NSString *logoStr = [[NSBundle mainBundle] pathForResource:@"aiduLogo" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:logoStr];
//// 分享到微信平台的配置
//    [UMSocialData defaultData].extConfig.wechatSessionData.url    = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title  = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//
//// 分享到qq平台的配置
//    [UMSocialData defaultData].extConfig.qqData.url      = sharedURLString;
//    [UMSocialData defaultData].extConfig.qqData.title    = sharedTitleString;
//    [UMSocialData defaultData].extConfig.qzoneData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitleString;
//
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//
//// 分享到微博平台的配置
//
//    NSString *sinaSharedContent = [NSString stringWithFormat:@"%@ %@",sharedContent,sharedURLString];
//
//    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaSharedContent;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = sharedURLString;
//
//    [UMSocialSnsService presentSnsIconSheetView:viewController
//                                         appKey:UMAppKey
//                                      shareText:sharedContent
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
//                                       delegate:viewController];
//}
//
//#pragma mark ------------------------------- 把癌小度功能分享到第三方平台
//+(void)sharedAiXiaoDuToOtherPlatFormWithTitle:(NSString*)searchKeyWord withViewController:(UIViewController*)viewController withSharedURL:(NSString*)url withIDString:(NSString*)idStr{
//
//    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
//    if (appDelegate.kTabBarController == nil) {
//        return;
//    }
//
//    if (searchKeyWord == nil) {
//        searchKeyWord = @"";
//    }
//
//    NSString *baseURL = url;
//    NSString *sharedURLString   = [NSString stringWithFormat:@"%@%@",baseURL,idStr];// ------------- 分享的连接
//    NSString *sharedTitleString = @"癌小度，“度”小癌！";// --------- 分享的默认标题
//
//    NSString *sharedContent = [NSString stringWithFormat:@"抗癌路上有问题，用“癌小度”智能搜索，搜easy！"];
//    if (searchKeyWord != nil && searchKeyWord.length > 0) {
//        sharedContent = nil;
//        sharedContent = [NSString stringWithFormat:@"%@",searchKeyWord];
//    }
//
//    NSString *logoStr = [[NSBundle mainBundle] pathForResource:@"AiXiaoDu3x" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:logoStr];
//
//// -------分享到微信平台的配置
//    [UMSocialData defaultData].extConfig.wechatSessionData.url    = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = sharedURLString;
//
//    [UMSocialData defaultData].extConfig.wechatSessionData.title  = sharedTitleString;
//
//    TXLog(@"searchKeyWord =======  %@",searchKeyWord);
//    TXLog(@"sharedURLString =====  %@",sharedURLString);
//
//    if (searchKeyWord != nil && searchKeyWord.length > 0) {
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = searchKeyWord;
//    }else{
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitleString;
//    }
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//
//
//// 分享到qq平台的配置
//    NSString *qqSharedURL = [NSString stringWithFormat:@"%@%@",baseURL,idStr];
//
//    [UMSocialData defaultData].extConfig.qqData.url      = qqSharedURL;
//    [UMSocialData defaultData].extConfig.qqData.title    = sharedTitleString;
//    [UMSocialData defaultData].extConfig.qzoneData.url   = qqSharedURL;
//    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitleString;
//
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//
//// 分享到微博平台的配置
//    NSString *sinaSharedContent = [NSString stringWithFormat:@"%@%@",sharedContent,qqSharedURL];
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType = UMSocialUrlResourceTypeDefault;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = qqSharedURL;
//    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaSharedContent;
//
//
//    [UMSocialSnsService presentSnsIconSheetView:(viewController == nil)?appDelegate.kTabBarController:viewController
//                                         appKey:UMAppKey
//                                      shareText:sharedContent
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
//                                       delegate:viewController];
//}
//
//#pragma mark ------------------------------- 把视频微博功能分享到第三方平台
//+(void)sharedVideoWeiboToOtherPlatFormInViewController:(UIViewController*)viewController withVideoID:(NSString*)idString withModel:(KWeiBoModel*)model{
//    NSString *sharedURLString   = [NSString stringWithFormat:@"%@%@",VIDEO_WEIBO_SHARE_URL,idString];
//
//    NSString *userName = [NSString stringWithFormat:@"【%@】",model.nickName];
//    NSString *contentStr = [NSString stringWithFormat:@"%@",model.content];
//    if (contentStr == nil || contentStr.length < 1) {
//        contentStr = @"在癌度里的视频";
//    }
//
//    NSString *sharedTitleString = [NSString stringWithFormat:@"%@%@",userName,contentStr];
//
//    NSString *sharedContent = [NSString stringWithFormat:@"自助者天助,“度”癌用癌度!"];
//
//    NSString *logoStr = [[NSBundle mainBundle] pathForResource:@"viewWeiBoShared" ofType:@"png"];
//    UIImage *image    = [UIImage imageWithContentsOfFile:logoStr];
//
//// 分享到微信平台的配置
//    [UMSocialData defaultData].extConfig.wechatSessionData.url    = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title  = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//
//// 分享到qq平台的配置
//    [UMSocialData defaultData].extConfig.qqData.url      = sharedURLString;
//    [UMSocialData defaultData].extConfig.qqData.title    = sharedTitleString;
//    [UMSocialData defaultData].extConfig.qzoneData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitleString;
//
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//
//    // 分享到微博平台的配置
//
//    NSString *sinaSharedContent = [NSString stringWithFormat:@"%@ %@",sharedContent,sharedURLString];
//
//    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaSharedContent;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = sharedURLString;
//
//    [UMSocialSnsService presentSnsIconSheetView:viewController
//                                         appKey:UMAppKey
//                                      shareText:sharedContent
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
//                                       delegate:viewController];
//}
//
//+(void)sharedYZWebViewToOtherPlatFormInViewController:(UIViewController*)viewController withURLString:(NSString *)sharedURLString withTitleString:(NSString *)sharedTitleString {
//
//    NSString *sharedContent = [NSString stringWithFormat:@"基因检测、预后护理、防癌体检黑科技应有尽有。"];
//
//    NSString *logoStr = [[NSBundle mainBundle] pathForResource:@"aiduLogo" ofType:@"png"];
//    UIImage *image    = [UIImage imageWithContentsOfFile:logoStr];
//
//    // 分享到微信平台的配置
//    [UMSocialData defaultData].extConfig.wechatSessionData.url    = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title  = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//
//    // 分享到qq平台的配置
//    [UMSocialData defaultData].extConfig.qqData.url      = sharedURLString;
//    [UMSocialData defaultData].extConfig.qqData.title    = sharedTitleString;
//    [UMSocialData defaultData].extConfig.qzoneData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitleString;
//
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//
//    // 分享到微博平台的配置
//
//    NSString *sinaSharedContent = [NSString stringWithFormat:@"%@ %@",sharedContent,sharedURLString];
//
//    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaSharedContent;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = sharedURLString;
//
//    [UMSocialSnsService presentSnsIconSheetView:viewController
//                                         appKey:UMAppKey
//                                      shareText:sharedContent
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
//                                       delegate:viewController];
//}
//
//
//+(void)sharedTreatmentRecordsDataLineWebViewToOtherPlatFormInViewController:(UIViewController*)viewController withURLString:(NSString *)sharedURLString withTitleString:(NSString *)sharedTitleString {
////    NSString *urlStr = @"https://test.xiangsibang.com/index.php?s=/home/quxian/index.html&token=";
////    NSString *urlStr = @"http://api.xiangsibang.com/index.php?s=/home/quxian/index.html&token=";
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ShareCurve_url,sharedURLString];
//
//    UserInforModel *userModel = [UserInforModel sharedUserInfor];
//
//    NSString *sharedContent = [NSString stringWithFormat:@"%@的肿瘤标志物变化曲线。",userModel.nickName];
//
//    NSString *logoStr = [[NSBundle mainBundle] pathForResource:@"aiduLogo" ofType:@"png"];
//    UIImage *image    = [UIImage imageWithContentsOfFile:logoStr];
//
//    // 分享到微信平台的配置
//    [UMSocialData defaultData].extConfig.wechatSessionData.url    = urlStr;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = urlStr;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title  = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//
//    // 分享到qq平台的配置
//    [UMSocialData defaultData].extConfig.qqData.url      = urlStr;
//    [UMSocialData defaultData].extConfig.qqData.title    = sharedTitleString;
//    [UMSocialData defaultData].extConfig.qzoneData.url   = urlStr;
//    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitleString;
//
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//
//    // 分享到微博平台的配置
//
//    NSString *sinaSharedContent = [NSString stringWithFormat:@"%@ %@",sharedContent,urlStr];
//
//    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaSharedContent;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = urlStr;
//
//    [UMSocialSnsService presentSnsIconSheetView:viewController
//                                         appKey:UMAppKey
//                                      shareText:sharedContent
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
//                                       delegate:viewController];
//}
//
//+(void)sharedLiveToOtherPlatFormInViewController:(UIViewController*)viewController {
//    NSString *sharedURLString   = @"http://api.xiangsibang.com/index.php?s=/Home/share/shareZhibo";
//
//    NSString *sharedTitleString = @"癌度直播号：大咖直播开始了！";
//
//    NSString *sharedContent = [NSString stringWithFormat:@"自助者天助,“度”癌用癌度!"];
//
//    NSString *logoStr = [[NSBundle mainBundle] pathForResource:@"viewWeiBoShared" ofType:@"png"];
//    UIImage *image    = [UIImage imageWithContentsOfFile:logoStr];
//
//    // 分享到微信平台的配置
//    [UMSocialData defaultData].extConfig.wechatSessionData.url    = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title  = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitleString;
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//
//    // 分享到qq平台的配置
//    [UMSocialData defaultData].extConfig.qqData.url      = sharedURLString;
//    [UMSocialData defaultData].extConfig.qqData.title    = sharedTitleString;
//    [UMSocialData defaultData].extConfig.qzoneData.url   = sharedURLString;
//    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitleString;
//
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//
//    // 分享到微博平台的配置
//
//    NSString *sinaSharedContent = [NSString stringWithFormat:@"%@ %@",sharedContent,sharedURLString];
//
//    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaSharedContent;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = sharedURLString;
//
//    [UMSocialSnsService presentSnsIconSheetView:viewController
//                                         appKey:UMAppKey
//                                      shareText:sharedContent
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
//                                       delegate:viewController];
//}
//
+(UIImage*)thumbnailImageForVideo:(NSString*)videoPath atTime:(NSTimeInterval)time{

    if (videoPath == nil || videoPath.length < 1) {
        return nil;
    }

    if ([videoPath hasPrefix:@"file"]) {
        videoPath = [videoPath substringFromIndex:16];
    }

    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
//    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//    generator.appliesPreferredTrackTransform = YES;
////    generator.maximumSize = CGSizeMake(size.width, size.height);
//    NSError *error = nil;
//    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
//    {
//        return [UIImage imageWithCGImage:img];
//    }
//    return nil;
    

    AVURLAsset *avURLAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//    NSParameterAssert(avURLAsset);

    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avURLAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

    CFTimeInterval thumbnilImageTime = 0;
    NSError *thumbnilError = nil;

    CGImageRef cgimage = [imageGenerator copyCGImageAtTime:CMTimeMake(thumbnilImageTime, 11) actualTime:NULL error:&thumbnilError];

    return [UIImage imageWithCGImage:cgimage];
}
//
//+(NSString*)getRandromGroupIDString{
//
//    UserInforModel *userModel = [UserInforModel sharedUserInfor];
//
//    if (userModel.uid.length < 1) {
//        return @"";
//    }
//
//    // 生成32位数字
//    NSInteger  suffix = arc4random()%INT_MAX;
//
//    NSString *uidStr  = [NSString stringWithFormat:@"%@",userModel.uid];
//    NSString *randStr = [NSString stringWithFormat:@"%ld",(long)suffix];
//    if (randStr.length < 10) {
//        for (int i = 0; i < 10-randStr.length; i++) {
//            randStr = [@"0" stringByAppendingString:randStr];
//        }
//    }
//
//    return [NSString stringWithFormat:@"%@%@",uidStr,randStr];
//}
//
//#pragma mark 获取视频时长
+(NSString*)getVideoDurationFromDuration:(CGFloat)duration{

    NSInteger time = (NSInteger)(duration *10);
    NSInteger second = time/10;
    NSInteger t2 = time%10;
    if (t2 >= 5) {
        second+=1;
    }

    if (second < 60) {
        NSString *secondStr = [NSString stringWithFormat:@"00:%ld",(long)second];
        if (second < 10) {
            secondStr = [NSString stringWithFormat:@"00:0%ld",(long)second];
        }
        return secondStr;
    }else if (second < 3600){
        NSInteger min = second / 60;
        NSInteger sec = second % 60;

        NSString *minStr = [NSString stringWithFormat:@"%ld",(long)min];
        NSString *secStr = [NSString stringWithFormat:@"%ld",(long)sec];
        if (sec < 10) {
            secStr = [@"0" stringByAppendingString:secStr];
        }

        return [NSString stringWithFormat:@"%@:%@",minStr,secStr];
    }else{
        NSInteger hour = second / 3600;
        NSInteger min  = (second - hour*3600)/60;
        NSInteger sec  = (second - hour*3600 - min*60);
        NSString *minStr = [NSString stringWithFormat:@"%ld",(long)min];
        if (min < 10) {
            minStr = [@"0" stringByAppendingString:minStr];
        }

        NSString *secStr = [NSString stringWithFormat:@"%ld",(long)sec];
        if (sec < 10) {
            secStr = [@"0" stringByAppendingString:secStr];
        }

        return [NSString stringWithFormat:@"%ld:%@:%@",(long)hour,minStr,secStr];
    }
}
//
//+ (NSString *)getStringFromDict:(NSDictionary*)dict withKey:(id)key{
//
//    NSString *string = @"";
//    if (dict && [dict objectForKey:key]) {
//        string = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
//    }
//
//    if (string == nil || [string isBlankString]) {
//        string = @"";
//    }
//
//    return string;
//}
//
//
//+(NSArray*)getHTMLRangesFromString:(NSString*)string{
//
//    NSError *error;
//
//    NSString *regulaStr = @"(http:\\/\\/)?(\\w+\\.)+\\w+(\\/[\\w- ./?%&=]*)?";
//
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
//
//                                                                           options:NSRegularExpressionCaseInsensitive
//
//                                                                             error:&error];
//
//    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
//
//    NSMutableArray *rangeArr=[[NSMutableArray alloc]init];
//
//
//    for (NSTextCheckingResult *match in arrayOfAllMatches){
//        NSString* substringForMatch;
//
//        substringForMatch = [string substringWithRange:match.range];
//
//        if ([string rangeOfString:substringForMatch].location != NSNotFound) {
//
//            if ([substringForMatch rangeOfString:@"xiangsibang.com"].location != NSNotFound) {
//                NSValue *value = [NSValue valueWithRange:match.range];
//                [rangeArr addObject:value];
//            }
//        }
//    }
//
//    return rangeArr;
//}
//
//+(NSArray*)getHTMLsFromString:(NSString*)string{
//
//    NSError *error;
//
////可以识别url的正则表达式
//    NSString *regulaStr = @"(http:\\/\\/)?(\\w+\\.)+\\w+(\\/[\\w- ./?%&=]*)?";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
//
//                                                                           options:NSRegularExpressionCaseInsensitive
//
//                                                                             error:&error];
//
//    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
//
//    NSMutableArray *urlArray=[[NSMutableArray alloc]init];
//
//    for (NSTextCheckingResult *match in arrayOfAllMatches){
//        NSString* substringForMatch = [string substringWithRange:match.range];
//        if ([string rangeOfString:substringForMatch].location != NSNotFound) {
//
//            if ([substringForMatch rangeOfString:@"xiangsibang.com"].location != NSNotFound) {
//                [urlArray addObject:substringForMatch];
//            }
//        }
//    }
//
//    return urlArray;
//}
//
//+(void)copyText:(NSString*)text{
//
////    NSString *originStr = [NSString stringWithFormat:@"%@",text];
////    if ([originStr rangeOfString:@"\n"].location != NSNotFound) {
////        originStr = [originStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
////    }
//
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
////    pasteboard.string = originStr;
//    pasteboard.string = text;
//}
//
//+(NSMutableAttributedString*)getMutableAttributedStringFromString:(NSString*)string
//                                                         withFont:(UIFont*)font
//                                                    withTextColor:(UIColor *)textColor
//                                                    withLineSpace:(CGFloat)lineSpace{
//
//    NSMutableParagraphStyle *pagraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [pagraphStyle setLineSpacing:lineSpace];
//    [pagraphStyle setAlignment:NSTextAlignmentJustified];
////    [pagraphStyle setParagraphSpacing:AD_HEIGHT(5.0)];
//
//    NSDictionary *attributedDict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,textColor,NSForegroundColorAttributeName,pagraphStyle,NSParagraphStyleAttributeName, nil];
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributedDict];
//
//    return attributedString;
//}
//
//#pragma mark  注册微信
//+ (void)registerWeChat{
//    [WXApi registerApp:WECHAT_AppId withDescription:@"com.xiangsibang.aidu"];
//}
//
//+ (void)showAlertWithTitle:(NSString*)str{
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
//    [appDelegate.window addSubview:HUD];
//    HUD.labelText = str;
//    HUD.mode = MBProgressHUDModeCustomView;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//    }];
//}
//
////在UserDefault中存储对象
//+ (void)storeObjectInUserDefaultWithObject:(id)object key:(NSString*)key {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:object forKey:key];
//    [userDefaults synchronize];
//}
////在UserDefault中获取对象
//+ (id)getObjectFromUserDefaultWithObject:(NSString*)key {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    return [userDefaults objectForKey:key];
//}
//
//+ (UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//
//    if ([nextResponder isKindOfClass:[UIViewController class]]) {
//
//        result = nextResponder;
//    } else {
//
//        result = window.rootViewController;
//    }
//
//    return result;
//}

@end
