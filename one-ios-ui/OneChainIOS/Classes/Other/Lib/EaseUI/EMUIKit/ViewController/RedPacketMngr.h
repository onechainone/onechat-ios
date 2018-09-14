//
//  RedPacketMngr.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/22.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

// 请求Token成功后的通知
FOUNDATION_EXTERN NSString *const GotTokenSuccessNotification;

typedef NS_ENUM(NSInteger, GetTokenStatus) {
    GetTokenStatusSuccess = 0,      /** 请求保存token成功 */
    GetTokenStatusLoading,          /** 正在请求token */
    GetTokenStatusFail,             /** 请求token失败 */
};

@class RedbagModel;
@interface RedPacketMngr : NSObject

@property (nonatomic) BOOL isGettingToken;

+ (instancetype)sharedMngr;

+ (BOOL)saveStatusAfterClick:(NSString *)redpacket_id;
// 获取红包是否已经抢过
+(BOOL)redpacketStatus:(NSString *)redpacket_id;

// 登录
+ (void)loginWithCompletetion:(void (^)(GetTokenStatus status))completetion;
+ (void)reLoginWithCompletetion:(void (^)(GetTokenStatus status))completetion;
// 获取token
+ (NSString *)getToken;

// 清除本地存储的token
+ (void)clearToken;

// token失效，跳转到签名界面
+ (void)showPasswordVC;

// 顶部控制器
+ (UIViewController *)topViewController;

// 本地语言
+ (NSString *)localLaungage;

+ (void)shareMiningImage:(UIImage *)shareImage;
@end
