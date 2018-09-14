//
//  MTool.h
//  ChatDemo
//
//  Created by hugaowei on 16/5/21.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//#import "NetworkingAlertView.h"
//#import "NetworkingWrongAlertView.h"

extern NSString *const UserInformation_Plist;
extern NSString *const UserInformation;
extern NSString *const Note_Configure;

typedef void(^GetCityBlock)(NSString *city);

//@class KWeiBoModel;

@interface MTool : NSObject

//- (void)getCurrentLocation:(GetCityBlock)cityBlock;
///**
// 生产一组头像图标,大小固定为80
//
// @param array 图像地址数组
// @param bgColor 背景颜色
// @return 多个头像的图标视图
// */
//+ (UIView *)groupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor;
//
///*
// 根据设备的不同，设置不同的标题大小
// */
//+(UIFont*)tabBarFontAccordingDevice;
//+(UIFont*)navigationBarTitleFont;
+(UIFont*)navigationItemFont;
//
///**
// *  判断手机号码
// */
//+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//
///*!
// * 判断当前网络连接状态 NO:没网络  YES:有网络
// */
//+(BOOL)checkCurrentNetState;
//
///*!
// * 网络无连接的提示
// */
//+ (void)showNoNetAlert;
//
///*
// * 把时间xxxx-xx-xx xx:xx 转换成 xxxx年xx月xx日 xx:xx
// * @param str 时间字符串
// */
//+(NSString*)getYearMonthDayFromString:(NSString*)str;
//
//
///**
// 返回以后的时间
//
// @param date 以后的日期
// @return 以后的时间
// */
//+(NSString*)getDateStringFromDateBefore:(NSDate*)date;
//
//
///**
// 返回倒计时时间“**天**小时**分**秒”
//
// @param date 时间戳
// @return 倒计时字符串
// */
//+(NSString*)getCountdownFromDateBefore:(NSDate*)date;
///*
// * 保存数据到本地plist文件
// * @param dict 要存储的数据
// * @param typeStr dict对应的key值
// * @param fileName 文件名
// */
//+(void)saveData:(NSDictionary*)dict forType:(NSString *)typeStr  filePath:(NSString*)fileName;
//
///**
// * 从本地文件读取数据
// * @param fileName 文件名称 （之后会拼接成完整的本地沙盒路径）
// * @param typeStr  key值，读取fileName文件之后，返回一个字典，如果typeStr==nil返回该字典，
// *                                                       如果typeStr!=nil，返回字典对应的value，该value的类型也是一个字典
// */
//+(NSDictionary*)readDataFromPlistFile:(NSString*)fileName withType:(NSString*)typeStr;
//
//+(CGRect)getAdjustFrame:(CGRect)frame;
//
///*
// * 根据文件后缀，返回该文件的沙盒绝对路径
// * @param suffixStr 文件后缀（文件名称）
// */
//+(NSString *)getDocumentPahtWithSuffix:(NSString*)suffixStr;
//
//
///**
// *  错误提示
// * @param message 提示内容
// * @param viewController AlertView显示在的那个controller
// */
+ (void)showWrongAlertViewWithMessage:(NSString*)message viewController:(UIViewController*)viewController;
//
+(void)showLoginAlertView:(UIViewController *)controller withSelector:(SEL)selector;

/*
 * 根据字符串，获取CGRect
 * @param str 需要计算的字符串
 * @param size 指定的size范围
 * @param font 指定的计算字体
 */
+(CGRect)getFrameWithString:(NSString*)str size:(CGSize)size font:(UIFont*)font;
//
///*
// * 根据字符串，获取CGRect
// * @param str 需要计算的字符串
// * @param size 指定的size范围
// * @param font 指定的计算字体
// * @param lineSpacing 行间隙
// */
//+ (CGRect)getFrameWithString:(NSString *)string withSize:(CGSize)size withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing;
//
///*
// * 发送网络请求时的提示框
// * @param title 提示内容
// */
//+(void)showNetworkingWaitingViewWithTitle:(NSString*)title;
//
/*
 *隐藏网络等待提示框
 */
+(void)networkingWaitingViewHidden;
//
///*
// * 网络请求 返回错误信息的提示
// * @param title 提示内容
// */
//+(void)showNetworkingWrongViewWithTitle:(NSString*)title;
//
///*
// * 登录
// */
//+(void)login:(UIViewController*)viewController;
//
///*
// * 显示网络请求成功的提示
// */
//+(void)showRequestSuccessAlert:(NSString*)content inView:(UIView*)view;
//
///*
// * 显示网络请求成功的提示
// */
//+(void)showRequestFailedAlert:(NSString*)content inView:(UIView*)view;
//
///*
// * 根据时间返回时间字符串，比如：刚刚和多数分钟前
// */
//+(NSString*)getDateStringFromDate:(NSDate*)date;
//
//+(void)sharedAppToOtherPlatFormInViewController:(UIViewController*)viewController;
//
//+(void)sharedAiXiaoDuToOtherPlatFormWithTitle:(NSString*)searchKeyWord withViewController:(UIViewController*)viewController withSharedURL:(NSString*)url withIDString:(NSString*)idStr;
//
//+(void)sharedVideoWeiboToOtherPlatFormInViewController:(UIViewController*)viewController withVideoID:(NSString*)idString withModel:(KWeiBoModel*)model;
//
//+(void)sharedYZWebViewToOtherPlatFormInViewController:(UIViewController*)viewController withURLString:(NSString *)sharedURLString withTitleString:(NSString *)sharedTitleString;
//
//+(void)sharedTreatmentRecordsDataLineWebViewToOtherPlatFormInViewController:(UIViewController*)viewController withURLString:(NSString *)sharedURLString withTitleString:(NSString *)sharedTitleString;
//
//+(void)sharedLiveToOtherPlatFormInViewController:(UIViewController*)viewController;
//
////返回一个随机32位数的字符串
//+(NSString*)getRandromGroupIDString;
//
+(UIImage*)thumbnailImageForVideo:(NSString*)videoPath atTime:(NSTimeInterval)time;
//
//返回一个视频时长的字符串
+(NSString*)getVideoDurationFromDuration:(CGFloat)duration;
//
//+(NSString *)getStringFromDict:(NSDictionary*)dict withKey:(id)key;
//
///**
// * 获取字符串中所有的图片链接的位置
// */
//+(NSArray*)getHTMLRangesFromString:(NSString*)string;
//
///**
// * 获取字符串中所有的图片链接
// */
//+(NSArray*)getHTMLsFromString:(NSString*)string;
//
///**
// * 复制
// */
//
//+(void)copyText:(NSString*)text;
//
//+(NSMutableAttributedString*)getMutableAttributedStringFromString:(NSString*)string
//                                                         withFont:(UIFont*)font
//                                                    withTextColor:(UIColor *)textColor
//                                                    withLineSpace:(CGFloat)lineSpace;
//
///**
// * 微信注册
// */
//
//+ (void)registerWeChat;
//
//+ (void)showAlertWithTitle:(NSString*)str;
//
////在UserDefault中存储对象
//+ (void)storeObjectInUserDefaultWithObject:(id)object key:(NSString*)key;
////在UserDefault中获取对象
//+ (id)getObjectFromUserDefaultWithObject:(NSString*)key;
//
//+ (UIViewController *)getCurrentVC;

@end
