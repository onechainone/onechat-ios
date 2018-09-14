//
//  MOBShareSDKHelper.m
//  ShareSDKDemo
//
//  Created by youzu on 2017/6/1.
//  Copyright © 2017年 mob. All rights reserved.
//
#import "MOBShareSDKHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK+Base.h>

//新浪微博需要引入的头文件
#ifdef IMPORT_SINA_WEIBO
#import "WeiboSDK.h"
#endif
//微信需要引入的头文件
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
#import "WXApi.h"
#endif

//FacebookMessenger需要引入的头文件
#ifdef IMPORT_FacebookMessenger
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#endif
//Line需要引入的头文件
#ifdef IMPORT_Line
#import <LineSDK/LineSDK.h>
#endif
//KaKao需要引入的头文件
#if (defined IMPORT_SUB_KakaoTalk) || (defined IMPORT_SUB_KakaoStory)
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#endif

//微信回调
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
@interface MOBShareSDKHelper ()<WXApiDelegate>
{
    
}
@end
#endif


@implementation MOBShareSDKHelper

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasGetAppKey:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)hasGetAppKey:(NSNotification *)notification
{
        [MOBShareSDKHelper shareInstance].platforems = [MOBShareSDKHelper _getPlatforems];
        [ShareSDK registerActivePlatforms:[MOBShareSDKHelper shareInstance].platforems
                                 onImport:^(SSDKPlatformType platformType) {
                                     [MOBShareSDKHelper _setConnectorWithPlatformType:platformType];
                                 }
                          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                              [MOBShareSDKHelper _setConfigurationWithPlatformType:platformType appInfo:appInfo];
                          }];
}

//注册平台
+ (NSArray *)_getPlatforems
{
    NSMutableArray *platforems = [NSMutableArray array];

    //微信好友
#ifdef IMPORT_SUB_WechatSession
    [platforems addObject:@(SSDKPlatformSubTypeWechatSession)];
#endif
    //微信朋友圈
#ifdef IMPORT_SUB_WechatTimeline
    [platforems addObject:@(SSDKPlatformSubTypeWechatTimeline)];
#endif
    //微博
#ifdef IMPORT_SINA_WEIBO
    [platforems addObject:@(SSDKPlatformTypeSinaWeibo)];
#endif
    //Facebook
#ifdef IMPORT_Facebook
    [platforems addObject:@(SSDKPlatformTypeFacebook)];
#endif
    //FacebookMessenger
#ifdef IMPORT_FacebookMessenger
     [platforems addObject:@(SSDKPlatformTypeFacebookMessenger)];
#endif
    //Twitter
#ifdef IMPORT_Twitter
    [platforems addObject:@(SSDKPlatformTypeTwitter)];
#endif
    //Line
#ifdef IMPORT_Line
    [platforems addObject:@(SSDKPlatformTypeLine)];
#endif
    //WhatsApp
#ifdef IMPORT_WhatsApp
    [platforems addObject:@(SSDKPlatformTypeWhatsApp)];
#endif

    //KakaoTalk
#ifdef IMPORT_SUB_KakaoTalk
    [platforems addObject:@(SSDKPlatformSubTypeKakaoTalk)];
#endif
    //SMS
#ifdef IMPORT_SMS
    [platforems addObject:@(SSDKPlatformTypeSMS)];
#endif
    //Mail
#ifdef IMPORT_Mail
    [platforems addObject:@(SSDKPlatformTypeMail)];
#endif
    return platforems;
}

//注册平台依赖 Connector
+ (void)_setConnectorWithPlatformType:(SSDKPlatformType)platformType
{
    switch (platformType) {
            //新浪微博
        case SSDKPlatformTypeSinaWeibo:
#ifdef IMPORT_SINA_WEIBO
           [ShareSDKConnector connectWeibo:[WeiboSDK class]];
#endif
            break;

            //微信
        case SSDKPlatformTypeWechat:
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
            //如需要获取微信的回调则 在delegate中设置 需实现 WXApiDelegate协议
            [ShareSDKConnector connectWeChat:[WXApi class] delegate:[MOBShareSDKHelper shareInstance]];
#endif
            break;
            //FacebookMessager
        case SSDKPlatformTypeFacebookMessenger:
#ifdef IMPORT_FacebookMessenger
            [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
#endif
            break;
            //Line
        case SSDKPlatformTypeLine:
#ifdef IMPORT_Line
            [ShareSDKConnector connectLine:[LineSDKLogin class]];
#endif
            break;
            //Kakao
        case SSDKPlatformTypeKakao:
#if (defined IMPORT_SUB_KakaoTalk) || (defined IMPORT_SUB_KakaoStory)
            [ShareSDKConnector connectKaKao:[KOSession class]];
#endif
            break;
        default:
            break;
    }
}

//注册平台信息
+ (void)_setConfigurationWithPlatformType:(SSDKPlatformType)platformType appInfo:(NSMutableDictionary *)appInfo
{
    switch (platformType) {
            //新浪微博
        case SSDKPlatformTypeSinaWeibo:
#ifdef IMPORT_SINA_WEIBO
            #pragma mark - 新浪微博 增加权限
            //增加默认权限 如：关注官方微博
//                   [appInfo SSDKSetAuthSettings:@[@"follow_app_official_microblog"]];
            [appInfo SSDKSetupSinaWeiboByAppKey:MOBSSDKSinaWeiboAppKey
                                      appSecret:MOBSSDKSinaWeiboAppSecret
                                    redirectUri:MOBSSDKSinaWeiboRedirectUri
                                       authType:MOBSSDKSinaWeiboAuthType];
#endif
            break;
            //微信
        case SSDKPlatformTypeWechat:
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
            [appInfo SSDKSetupWeChatByAppId:MOBSSDKWeChatAppID
                                  appSecret:MOBSSDKWeChatAppSecret
                                backUnionID:MOBSSDKWeChatBackUnionID];
#endif
            break;
            //Facebook
        case SSDKPlatformTypeFacebook:
        case SSDKPlatformTypeFacebookMessenger:
#ifdef IMPORT_Facebook
            #pragma mark - Facebook 重设权限
//                  [appInfo SSDKSetAuthSettings:@[
//                                                 @"public_profile",//默认(无需审核)
//                                                 @"user_friends",//好友列表(无需审核)
//                                                 @"email",//邮箱(无需审核)
//                                                 @"user_about_me",//用户个人说明(需审核)
//                                                 @"publish_actions",//应用内分享 必要权限(需审核)
//                                                 @"user_videos"//应用内视频分享 必要权限(需审核)
//                                                 ]];
            [appInfo SSDKSetupFacebookByApiKey:MOBSSDKFacebookAppID
                                     appSecret:MOBSSDKFacebookAppSecret
                                   displayName:MOBSSDKFacebookDisplayName
                                      authType:MOBSSDKFacebookAuthType];
#endif
            break;

            //Twitter
        case SSDKPlatformTypeTwitter:
#ifdef IMPORT_Twitter
        [appInfo SSDKSetupTwitterByConsumerKey:MOBSSDKTwitterConsumerKey
                                consumerSecret:MOBSSDKTwitterConsumerSecret
                                   redirectUri:MOBSSDKTwitterRedirectUri];
#endif
            break;
            //Line
        case SSDKPlatformTypeLine:
#ifdef IMPORT_Line
            [appInfo SSDKSetupLineAuthType:MOBSSDKLineAuthType];
#endif
            break;

            //Kakao
        case SSDKPlatformTypeKakao:
#if (defined IMPORT_SUB_KakaoTalk) || (defined IMPORT_SUB_KakaoStory)
            [appInfo SSDKSetupKaKaoByAppKey:MOBSSDKKaKaoAppKey
                                 restApiKey:MOBSSDKKaKaoRestApiKey
                                redirectUri:MOBSSDKKaKaoRedirectUri
                                   authType:MOBSSDKKaKaoAuthType];
#endif
            break;
        case SSDKPlatformTypeSMS:
#ifdef IMPORT_SMS
            [appInfo SSDKSetpSMSOpenCountryList:MOBSSDKSMSOpenCountryList];
#endif
            break;
        default:
            break;
    }
}


+ (MOBShareSDKHelper *)shareInstance
{
    static MOBShareSDKHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MOBShareSDKHelper alloc] init];
    });
    return helper;
}

#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
//微信的回调
-(void) onReq:(BaseReq*)req
{
    NSLog(@"wechat req %@",req);
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"wechat resp %@",resp);
}
#endif
@end
